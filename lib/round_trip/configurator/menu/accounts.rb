require 'round_trip/configurator/menu/base'
require 'round_trip/configurator/presenter/account'
require 'round_trip/configurator/menu/account'

module RoundTrip
  class Configurator::Menu::Accounts < Configurator::Menu::Base
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
        menu.header    = 'RoundTrip - manage accounts'
        menu.flow      = :columns_down
        menu.prompt    = 'What now> '
        menu.select_by = :index_or_name
        Account.all.each do |account|
          menu.choice(account.name) do
            account_presenter = Configurator::Presenter::Project.new(project)
            Configurator::Menu::Account.new(high_line, account_presenter).run
          end
        end
        menu.choice('add a Redmine account') do
          name = high_line.ask('name: ')
          if name.match(/^[\w\s\d]+$/)
            RedmineAccount.create!(name: name)
          end
        end
        menu.choice('add a Trello account') do
          name = high_line.ask('name: ')
          if name.match(/^[\w\s\d]+$/)
            TrelloAccount.create!(name: name)
          end
        end
        menu.choice('quit (q)') do
          return true
        end
      end
      false
    end
  end
end

