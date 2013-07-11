module RoundTrip
  module Trello; end

  class Trello::ListMap
    attr_reader :lists
    attr_reader :area_to_list
    attr_reader :list_to_area

    def initialize(lists)
      @lists  = lists
      @errors = nil
      prepare_mappings
    end

    def add_mapping(area, list)
      area_to_list[area]      << list
      list_to_area[list.name] << area
    end

    private

    def prepare_mappings
      @area_to_list = {}
      Trello::ListMatcher::AREAS.each do |area|
        @area_to_list[area] = []
      end

      @list_to_area = {}
      lists.each do |list|
        @list_to_area[list.name] = []
      end
    end
  end

  class Trello::ListMatcher
    AREAS = [:ideas, :backlog, :current, :done, :archived]

    attr_reader :project
    attr_reader :matchers

    def initialize(project)
      @project = project
      @lists = @matchers = @list_map = nil
    end

    def set_matchers(matchers)
      @list_map = nil
      @matchers = matchers
    end

    def lists
      return @lists unless @lists.nil?

      trello_account = project.trello_account
      authorizer = Trello::Authorizer.for_account(trello_account)
      board_id = project.config[:trello_board_id]
      board = authorizer.client.find(:boards, board_id)
      @lists = board.lists
    end

    def list_map
      return @list_map unless @list_map.nil?

      @list_map = Trello::ListMap.new(lists)

      AREAS.each do |area|
        if area != :archived
          rx = Regexp.new(matchers[area], Regexp::IGNORECASE)
          lists.each do |list|
            next if list.closed
            if list.name.match(rx)
              @list_map.add_mapping area, list
            end
          end
        else
          # TODO
        end
      end

      lists.each do |list|
        if @list_map.list_to_area[list.name].size == 0
          @list_map.add_mapping :current, list
        end
      end

      @list_map
    end

    def errors
      return @errors unless @errors.nil?

      @errors = []

      [:current, :done].each do |area|
        if list_map.area_to_list[area].size == 0
          @errors << "No lists found for #{area}"
        end
      end

      lists.each do |list|
        if list_map.list_to_area[list.name].size > 1
          @errors << "Multiple matches found for list #{list.name}"
        end
      end

      @errors
    end

    def to_s
      s = ''

      format = "%- 10s | %- #{longest_matcher}s | %s\n"
      s << format % ['Area', 'Matcher', 'Lists']
      s << '-' * s.size
      s << "\n"
      AREAS.each do |area|
        lists = list_map.area_to_list[area]
        names =
          if lists.size > 0
            lists.map(&:name)
          else
            ['(no lists found)']
          end
        s << format % [area, matchers[area], names.join(', ')]
      end

      if errors.size > 0
        s << "\nErrors:\n"
        s << errors.join("\n")
        s << "\n"
      end
      s
    end

    private

    def longest_matcher
      r = ''
      matchers.each { |area, m| r = m if m.size > r.size }
      r.size
    end
  end
end

