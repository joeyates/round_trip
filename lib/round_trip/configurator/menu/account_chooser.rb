require 'round_trip/configurator/menu/base'

module RoundTrip
  class Configurator::Menu::AccountChooser < Configurator::Menu::Base
    attr_reader :accounts

    def initialize(high_line, accounts)
      super(high_line)
      @accounts = accounts
    end

    def run
      system('clear')
      show_menu
    end

    private

    def show_menu
      high_line.choose do |menu|
        menu.header    = 'RoundTrip - choose an account'
        menu.flow      = :columns_down
        menu.prompt    = 'Choose one> '
        menu.select_by = :index_or_name
        accounts.each do |account|
          menu.choice(account.name) do
            return account
          end
        end
        menu.choice('quit (q)') do
          return nil
        end
      end
    end
  end
end

