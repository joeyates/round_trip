module RoundTrip
  class MatchedTicketUpdaterService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      project_tickets = Ticket.for_project(project.id)

      project_tickets.redmine_newer.each do |t|
        t.trello_name = t.redmine_subject
        t.trello_description = t.redmine_description
        t.save!
      end
      project_tickets.trello_newer.each do |t|
        t.redmine_subject = t.trello_name
        t.redmine_description = t.trello_description
        t.save!
      end
    end
  end
end

