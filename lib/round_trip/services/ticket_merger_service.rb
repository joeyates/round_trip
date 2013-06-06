module RoundTrip
  class TicketMergerService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      raise 'redmine project id not set' if project.config[:redmine_project_id].nil?
      raise 'redmine url not set' if project.config[:redmine_url].nil?
      raise 'trello board id not set' if project.config[:trello_board_id].nil?

      Ticket.check_repeated_redmine_ids(project.config[:redmine_project_id])
      Ticket.check_repeated_trello_ids(project.config[:trello_board_id])
      trello_with_redmine_id = Ticket.trello_has_redmine_id.not_united
      trello_with_redmine_id.all.each do |trello_ticket|
        redmine_ticket = Ticket.find(trello_ticket.trello_redmine_id)
        trello_ticket.merge_redmine redmine_ticket
      end
    end
  end
end

