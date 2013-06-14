require 'round_trip/configurator/menu/base'
require 'round_trip/configurator/menu/projects'

module RoundTrip
  class Configurator::Menu::Main < Configurator::Menu::Base
    def run
      loop do
        system('clear')
        done = show_menu
        return if done
      end
    end

    def show_menu
      high_line.choose do |menu|
        menu.header    = 'Choose a project'
        menu.flow      = :columns_down
        menu.prompt    = 'What now> '
        menu.select_by = :index_or_name
        menu.choice('manage projects') do
          Configurator::Menu::Projects.new(high_line).run
        end
        menu.choice('quit (q)') do
          return true
        end
      end
      false
    end
  end
end

