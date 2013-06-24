require 'round_trip/configurator/menu/base'

module RoundTrip
  class Configurator::Menu::TrelloListMatcherInput < Configurator::Menu::Base
    attr_reader :project
    attr_reader :list_matcher
    attr_reader :ideas
    attr_reader :backlog
    attr_reader :current
    attr_reader :done

    def initialize(high_line, project, list_matcher)
      super(high_line)
      @project = project
      @list_matcher = list_matcher
      ideas    = project.config[:ideas]   or 'ideas'
      backlog  = project.config[:backlog] or 'backlog'
      current  = project.config[:current] or 'sprint \d+'
      done     = project.config[:done]    or 'done \d+'
    end

    def run
      system('clear')
      show_menu
      [ideas, backlog, current, done]
    end

    private

    def show_menu
      high_line.choose do |menu|
        setup_list_matcher
        menu.header    = "RoundTrip - configure list matchers\n" +
                         list_matcher.to_s
        menu.flow      = :columns_down
        menu.prompt    = 'Choose one> '
        menu.select_by = :index_or_name
        menu.choice('quit (q)') do
          return nil
        end
      end
    end

    def setup_list_matcher
      list_matcher.setup(
        ideas: ideas,
        backlog: backlog,
        current: current,
        done: done
      )
    end
  end
end

