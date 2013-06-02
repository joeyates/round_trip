require 'round_trip/configurator/menu/base'
require 'round_trip/redmine/connection_tester'
require 'round_trip/trello/connection_tester'

class RoundTrip::Configurator::Menu::Project < RoundTrip::Configurator::Menu::Base
  def run(project)
    loop do
      system('clear')
      high_line.choose do |menu|
        menu.header = project.to_s + "\n\nEdit a setting"
        menu.choice('name') do
          project.name = high_line.ask("name: ")
        end
        project.each_configuration do |key, human_name, value|
          menu.choice(human_name) do
            project.config[key] = high_line.ask("#{human_name}: ")
          end
        end
        menu.choice('test redmine connection') do
          result, message = RoundTrip::Redmine::ConnectionTester.new(project).run
          high_line.ask "#{message}\nPress a key... "
        end
        menu.choice('test trello connection') do
          result, message = RoundTrip::Trello::ConnectionTester.new(project).run
          high_line.ask "#{message}\nPress a key... "
        end
        menu.choice('save') do
          project.save!
          system('clear')
          return
        end
        menu.choice('quit (q)') do
          system('clear')
          return
        end
      end
    end
  end
end
