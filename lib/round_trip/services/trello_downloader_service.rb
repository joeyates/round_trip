require 'round_trip/ticket'
require 'round_trip/trello/authorizer'

class RoundTrip::TrelloDownloaderService
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
    raise 'No board_id set' if round_trip_project.trello[:board_id].nil?
  end

  def run
    RoundTrip::Ticket.where(:trello_board_id => round_trip_project.trello[:board_id]).destroy_all
    authorizer = RoundTrip::Trello::Authorizer.new(round_trip_project.trello)
    board = authorizer.client.find(:boards, round_trip_project.trello[:board_id])
    board.cards.each do |card|
      RoundTrip::Ticket.create_from_trello_card(card)
    end
  end
end

