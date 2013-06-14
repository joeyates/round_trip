require 'round_trip/configurator/menu/base'
require 'round_trip/redmine/connection_tester'
require 'round_trip/trello/connection_tester'

module RoundTrip
  class Configurator::Menu::Project < Configurator::Menu::Base
    attr_reader :project

    def initialize(high_line, project)
      super(high_line)
      @project = project
    end

    def run
      loop do
        system('clear')
        done = show_menu
        return if done
      end
    end

    def show_menu
      high_line.choose do |menu|
        menu.header    = project.to_s + "\n\nEdit a setting"
        menu.flow      = :columns_down
        menu.prompt    = 'What now> '
        menu.select_by = :index_or_name
        menu.choice('name') do
          project.name = high_line.ask("name: ") do |q|
            q.default = project.name if project.name and project.name != ''
          end
        end
        project.each_configuration do |key, human_name, value|
          menu.choice(human_name) do
            c = project.config.clone
            c[key] = high_line.ask("#{human_name}: ") do |q|
              q.default = c[key] if c[key]
            end
            project.config = c
          end
        end
        menu.choice('test redmine connection') do
          result, message = Redmine::ConnectionTester.new(project).run
          high_line.ask "#{message}\nPress a key... "
        end
        menu.choice('test trello connection') do
          result, message = Trello::ConnectionTester.new(project).run
          high_line.ask "#{message}\nPress a key... "
        end
        menu.choice('save') do
          project.save!
          return true
        end
        menu.choice('quit (q)') do
          if project.changed?
            confirmed = high_line.agree("The project has been modified.\nExit without saving? ")
            return true if confirmed
          else
            return true
          end
        end
      end
      false
    end
  end
end

