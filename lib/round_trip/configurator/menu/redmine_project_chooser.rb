require 'round_trip/configurator/menu/base'

module RoundTrip
  class Configurator::Menu::RedmineProjectChooser < Configurator::Menu::Base
    attr_reader :redmine_account

    def initialize(high_line, redmine_account)
      super(high_line)
      @redmine_account = redmine_account
    end

    def run
      system('clear')
      show_menu
    end

    private

    def show_menu
      high_line.choose do |menu|
        menu.header    = 'RoundTrip - choose a project'
        menu.flow      = :columns_down
        menu.prompt    = 'Choose one> '
        menu.select_by = :index_or_name
        redmine_account.projects.each do |project|
          menu.choice(project.name) do
            return project.id
          end
        end
        menu.choice('quit (q)') do
          return nil
        end
      end
    end
  end
end

