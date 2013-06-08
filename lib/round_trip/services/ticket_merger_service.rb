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
      trello_with_redmine_id = Ticket.for_project(project.id).trello_has_redmine_id.not_united
      trello_with_redmine_id.all.each do |trello_ticket|
        redmine_ticket = load_redmine_ticket(trello_ticket)
        trello_ticket.merge_redmine redmine_ticket
      end
    end

    def load_redmine_ticket(trello_ticket)
      Ticket.where(redmine_id: trello_ticket.trello_redmine_id).first or raise ActiveRecord::RecordNotFound
    end
  end
end

