require 'round_trip/configurator/presenter/base'

module RoundTrip
  module Configurator::Presenter; end

  class Configurator::Presenter::Project < Configurator::Presenter::Base
    private

    def display_pairs
      pairs = [
        ['name', name],
        ['redmine account', redmine_account],
        ['trello account', trello_account],
      ]
      pairs << ['redmine project', config[:redmine_project_id]] if redmine_account
      pairs << ['trello board', config[:trello_board_id]] if trello_account
      pairs
    end
  end
end

