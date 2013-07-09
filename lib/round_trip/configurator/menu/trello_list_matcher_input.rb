require 'round_trip/configurator/menu/base'

module RoundTrip
  class Configurator::Menu::TrelloListMatcherInput < Configurator::Menu::Base
    attr_reader :project
    attr_reader :list_matcher
    attr_reader :matchers
    attr_reader :dirty

    def initialize(high_line, project, list_matcher)
      super(high_line)
      @project = project
      @list_matcher = list_matcher
      @matchers = {
        ideas:    project.config[:ideas]   || 'ideas',
        backlog:  project.config[:backlog] || 'backlog',
        current:  project.config[:current] || 'sprint \d+',
        done:     project.config[:done]    || 'done \d+',
      }
      @dirty = false
    end

    def run
      loop do
        system('clear')
        done = show_menu
        return if done
      end
    end

    private

    def show_menu
      high_line.choose do |menu|
        setup_list_matcher
        menu.header    = "RoundTrip - configure lists\n" +
                         list_matcher.to_s
        menu.flow      = :columns_down
        menu.prompt    = 'Choose one> '
        menu.select_by = :index_or_name
        [:ideas, :backlog, :current, :done].each do |area|
          menu.choice(area.to_s) do
            result = high_line.ask('matcher: ') do |q|
              q.default = matchers[area]
            end
            @dirty = true
            matchers[area] = result
          end
        end
        menu.choice('save') do
          project.config = project.config.merge(matchers)
          project.save!
          return true
        end
        menu.choice('quit (q)') do
          if dirty
            confirmed = high_line.agree("The matchers have been modified.\nExit without saving? ")
            return confirmed
          else
            return true
          end
        end
      end
      false
    end

    def setup_list_matcher
      list_matcher.set_matchers(matchers)
    end
  end
end

