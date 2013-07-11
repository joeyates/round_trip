module RoundTrip
  class TicketMergerService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      raise 'redmine project id not set' if project.config[:redmine_project_id].nil?
      raise 'trello board id not set' if project.config[:trello_board_id].nil?

      Ticket.check_repeated_redmine_ids(project.config[:redmine_project_id])
      Ticket.check_repeated_trello_ids(project.config[:trello_board_id])
      Ticket.check_repeated_redmine_subjects(project.config[:redmine_project_id])
      Ticket.check_repeated_trello_names(project.config[:trello_board_id])

      not_united = Ticket.for_project(project.id).not_united

      not_united.trello_has_redmine_id.all.each do |trello_ticket|
        redmine_ticket = load_redmine_ticket(trello_ticket)
        trello_ticket.merge_redmine redmine_ticket
      end

      not_united.redmine_has_trello_id.all.each do |redmine_ticket|
        trello_ticket = load_trello_ticket(redmine_ticket)
        redmine_ticket.merge_trello trello_ticket
      end

      Ticket.redmine_subject_with_matching_trello_name(project).each do |redmine_ticket|
        trello_ticket = not_united.without_redmine.where(trello_name: redmine_ticket.redmine_subject).first or raise ActiveRecord::RecordNotFound
        redmine_ticket.merge_trello trello_ticket
      end
    end

    private

    def load_redmine_ticket(trello_ticket)
      Ticket.where(redmine_id: trello_ticket.trello_redmine_id).first or raise ActiveRecord::RecordNotFound
    end

    def load_trello_ticket(redmine_ticket)
      Ticket.where(trello_id: redmine_ticket.redmine_trello_id).first or raise ActiveRecord::RecordNotFound
    end
  end
end

