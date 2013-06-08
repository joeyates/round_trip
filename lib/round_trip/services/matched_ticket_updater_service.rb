module RoundTrip
  class MatchedTicketUpdaterService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      Ticket.for_project(project.id).redmine_newer.each do |t|
        t.trello_name = t.redmine_subject
        t.trello_description = t.redmine_description
        t.save!
      end
      Ticket.for_project(project.id).trello_newer.each do |t|
        t.redmine_subject = t.trello_name
        t.redmine_description = t.trello_description
        t.save!
      end
    end
  end
end

