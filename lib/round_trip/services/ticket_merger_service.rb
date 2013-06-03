class RoundTrip::TicketMergerService
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
  end

  def run
    raise 'redmine project id not set' if round_trip_project.config[:redmine_project_id].nil?
    raise 'redmine url not set' if round_trip_project.config[:redmine_url].nil?
    raise 'trello board id not set' if round_trip_project.config[:trello_board_id].nil?

    RoundTrip::Ticket.check_repeated_redmine_ids(round_trip_project.config[:redmine_project_id])
    trello_with_redmine_id = RoundTrip::Ticket.trello_has_redmine_id.not_united
    trello_with_redmine_id.all.each do |trello_ticket|
      redmine_ticket = RoundTrip::Ticket.find(trello_ticket.trello_redmine_id)
      trello_ticket.merge_redmine redmine_ticket
    end
  end
end

