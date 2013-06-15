require 'round_trip/configurator/menu/base'
require 'round_trip/redmine/connection_tester'
require 'round_trip/trello/connection_tester'

module RoundTrip
  class Configurator::Menu::Account < Configurator::Menu::Base
    attr_reader :account

    def initialize(high_line, account)
      @account = account
      super(high_line)
    end

    def run
      loop do
        system('clear')
        done = show_menu
        return if done
      end
    end

    private

    def klass
      account.target.class
    end

    def type
      klass.to_s[/RoundTrip::(.*?)Account/, 1]
    end

    def tester_klass
      case
      when klass == RoundTrip::RedmineAccount
        Redmine::ConnectionTester
      when klass == RoundTrip::TrelloAccount
        Trello::ConnectionTester
      end
    end

    def show_menu
      high_line.choose do |menu|
        menu.header    = "RoundTrip - edit #{type} account: " + account.name + "\n\n" +
                         account.to_s + "\n\n" +
                         'Choose a setting'
        menu.flow      = :columns_down
        menu.prompt    = 'What now> '
        menu.select_by = :index_or_name
        menu.choice('name') do
          account.name = high_line.ask("name: ") do |q|
            q.default = account.name if account.name and account.name != ''
          end
        end
        account.each_configuration do |key, human_name|
          menu.choice(human_name) do
            c = account.config.clone
            c[key] = high_line.ask("#{human_name}: ") do |q|
              q.default = c[key] if c[key]
            end
            account.config = c
          end
        end
        menu.choice("test #{type} connection") do
          result, message = tester_klass.new(account).run
          high_line.ask "#{message}\nPress a key... "
        end
        menu.choice('save') do
          account.save!
          return true
        end
        menu.choice('quit (q)') do
          if account.changed?
            confirmed = high_line.agree("The account has been modified.\nExit without saving? ")
            return true if confirmed
          else
            return true
          end
        end
      end
      false
    end
  end
end

