require 'round_trip/models/ticket'
require 'round_trip/trello/authorizer'

module RoundTrip
  class TrelloDownloaderService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      raise 'No board_id set' if board_id.nil?
      Ticket.where(:trello_board_id => board_id).destroy_all
      authorizer = Trello::Authorizer.new(
        project.config[:trello_key],
        project.config[:trello_secret],
        project.config[:trello_token],
      )
      board = authorizer.client.find(:boards, board_id)
      cards = board.cards
      cards.each do |card|
        Ticket.create_from_trello_card(card)
      end
      RoundTrip.logger.info "#{cards.size} tickets imported from Trello board '#{board.name}'"
    end

    private

    def board_id
      project.config[:trello_board_id]
    end
  end
end

