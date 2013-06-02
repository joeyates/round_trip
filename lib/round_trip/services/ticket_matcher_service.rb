class RoundTrip::TicketMatcherService
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
  end

  def run
    raise 'redmine project id not set' if round_trip_project.config[:redmine_project_id].nil?
    raise 'redmine url not set' if round_trip_project.config[:redmine_url].nil?
    raise 'trello board id not set' if round_trip_project.config[:trello_board_id].nil?
  end
end

