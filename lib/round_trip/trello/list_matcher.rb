module RoundTrip
  module Trello; end

  class Trello::ListMatcher
    AREAS = [:ideas, :backlog, :current, :done, :archived]

    attr_reader :project
    attr_reader :matchers
    attr_reader :matches

    def initialize(project)
      @project = project
    end

    def set_matchers(matchers)
      @matchers = matchers
    end

    def lists
      return @lists if @lists
      trello_account = project.trello_account
      authorizer = Trello::Authorizer.for_account(trello_account)
      board_id = project.config[:trello_board_id]
      board = authorizer.client.find(:boards, board_id)
      @lists = board.lists
    end

    def to_s
      s = ''

      format = "%- 10s | %- #{longest_matcher}s | %s\n"
      s << format % ['Area', 'Matcher', 'Lists']
      s << '-' * s.size
      s << "\n"
      AREAS.each do |area|
        lists = matches[area]
        names =
          if lists.size > 0
            lists.map(&:name)
          else
            ['(no lists found)']
          end
        s << format % [area, matchers[area], names.join(', ')]
      end

      if @errors.size > 0
        s << "\nErrors:\n"
        s << @errors.join("\n")
        s << "\n"
      end
      s
    end

    def matches
      @matches = {}
      @matched = {}
      AREAS.each do |area|
        @matches[area] ||= []
        if area != :archived
          rx = Regexp.new(matchers[area], Regexp::IGNORECASE)
          lists.each do |list|
            @matched[list.name] ||= []
            if list.name.match(rx)
              @matches[area] << list
              @matched[list.name] << area
            end
          end
        else
          # TODO
        end
      end

      lists.each do |list|
        if @matched[list.name].size == 0
          @matches[:current] << list
          @matched[list.name] << :current
        end
      end

      check

      @matches
    end

    private

    def check
      @errors = []

      [:current, :done].each do |area|
        if @matches[area].size == 0
          @errors << "No lists found for #{area}"
        end
      end

      lists.each do |list|
        if @matched[list.name].size > 1
          @errors << "Multiple matches found for list #{list.name}"
        end
      end
    end

    def longest_matcher
      r = ''
      matchers.each { |area, m| r = m if m.size > r.size }
      r.size
    end
  end
end

