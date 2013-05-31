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
        project.each_configuration do |name, attribute, key, value|
          full_key_name = "#{name} #{key}"
          menu.choice(full_key_name) do
            attribute[key] = high_line.ask("#{full_key_name}: ")
          end
        end
        menu.choice('test redmine connection') do
          result, message = RoundTrip::Redmine::ConnectionTester.new(project.redmine).run
          high_line.ask "#{message}\nPress a key... "
        end
        menu.choice('test trello connection') do
          result, message = RoundTrip::Trello::ConnectionTester.new(project.trello).run
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

