require 'round_trip/configurator/menu/base'

module RoundTrip
  class Configurator::Menu::TrelloBoardChooser < Configurator::Menu::Base
    attr_reader :trello_account

    def initialize(high_line, trello_account)
      super(high_line)
      @trello_account = trello_account
    end

    def run
      system('clear')
      show_menu
    end

    private

    def show_menu
      high_line.choose do |menu|
        menu.header    = 'RoundTrip - choose a board'
        menu.flow      = :columns_down
        menu.prompt    = 'Choose one> '
        menu.select_by = :index_or_name
        trello_account.boards.each do |board|
          menu.choice(board.name) do
            return board.id
          end
        end
        menu.choice('quit (q)') do
          return nil
        end
      end
    end
  end
end

