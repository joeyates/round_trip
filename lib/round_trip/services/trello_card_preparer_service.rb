module RoundTrip
  class TrelloCardPreparerService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      Ticket.for_project(project.id).not_united.with_redmine.each do |t|
        t.trello_name = t.redmine_subject
        t.trello_description = t.redmine_description
        t.save!
      end
    end
  end
end

