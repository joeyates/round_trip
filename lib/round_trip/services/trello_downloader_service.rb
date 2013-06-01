class RoundTrip::TrelloDownloaderService
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
    raise 'No board_id set' if round_trip_project.trello[:board_id].nil?
  end

  def run
    RoundTrip::Ticket.where(:trello_board_id => round_trip_project.trello[:board_id]).destroy_all
  end
end

