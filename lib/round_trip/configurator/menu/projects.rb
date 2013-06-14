require 'round_trip/configurator/menu/base'
require 'round_trip/configurator/menu/project'
require 'round_trip/configurator/presenter/project'

module RoundTrip
  class Configurator::Menu::Projects < Configurator::Menu::Base
    def run
      loop do
        system('clear')
        high_line.choose do |menu|
          menu.header    = 'RoundTrip - manage projects'
          menu.flow      = :columns_down
          menu.prompt    = 'What now> '
          menu.select_by = :index_or_name
          Project.all.each do |project|
            menu.choice(project.name) do
              project_presenter = Configurator::Presenter::Project.new(project)
              Configurator::Menu::Project.new(high_line, project_presenter).run
            end
          end
          menu.choice('add a project') do
            name = high_line.ask('name: ')
            if name.match(/^[\w\s\d]+$/)
              Project.create!(:name => name)
            end
          end
          menu.choice('quit (q)') do
            return
          end
        end
      end
    end
  end
end

