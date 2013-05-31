require 'round_trip/configurator/menu/base'
require 'round_trip/configurator/menu/project'
require 'round_trip/configurator/presenter/project'

class RoundTrip::Configurator::Menu::Main < RoundTrip::Configurator::Menu::Base
  def run
    loop do
      system('clear')
      high_line.choose do |menu|
        menu.header = 'Choose a project'
        RoundTrip::Project.all.each do |project|
          menu.choice(project.name) do
            RoundTrip::Configurator::Menu::Project.new(high_line).run(RoundTrip::Configurator::Presenter::Project.new(project))
          end
        end
        menu.choice('add a project') do
          name = high_line.ask('name: ')
          if name.match(/^[\w\s\d]+$/)
            RoundTrip::Project.create!(:name => name)
          end
        end
        menu.choice('quit (q)') do
          system('clear')
          return
        end
      end
    end
  end
end

