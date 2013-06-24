require 'round_trip/configurator/menu/base'
require 'round_trip/configurator/menu/account_chooser'
require 'round_trip/configurator/menu/redmine_project_chooser'
require 'round_trip/configurator/menu/trello_board_chooser'

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

    private

    def show_menu
      high_line.choose do |menu|
        menu.header    = "RoundTrip - editing project\n" +
                         project.to_s + "\n\n" +
                         'Choose a setting'
        menu.flow      = :columns_down
        menu.prompt    = 'What now> '
        menu.select_by = :index_or_name
        menu.choice('name') do
          project.name = high_line.ask("name: ") do |q|
            q.default = project.name if project.name and project.name != ''
          end
        end
        menu.choice('redmine account') do
          account = Configurator::Menu::AccountChooser.new(high_line, RedmineAccount.all).run
          if not account.nil?
            project.redmine_account = account
          end
        end
        if project.redmine_account
          menu.choice('redmine project') do
           redmine_project_id = Configurator::Menu::RedmineProjectChooser.new(high_line, project.redmine_account).run
           set_config(:redmine_project_id, redmine_project_id) unless redmine_project_id.nil?
          end
        end
        menu.choice('trello account') do
          account = Configurator::Menu::AccountChooser.new(high_line, TrelloAccount.all).run
          if not account.nil?
            project.trello_account = account
          end
        end
        if project.trello_account
          menu.choice('trello board') do
            trello_board_id = Configurator::Menu::TrelloBoardChooser.new(high_line, project.trello_account).run
            set_config(:trello_board_id, trello_board_id) unless trello_board_id.nil?
          end
        end
        if project.config[:trello_board_id]
          menu.choice('trello list matchers') do
            ideas_list, backlog_list, current_list, done_list = Configurator::Menu::TrelloListMatcherInput.new(high_line, project).run
          end
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

    def set_config(key, value)
      c = project.config.clone
      c[key] = value
      project.config = c
    end
  end
end

