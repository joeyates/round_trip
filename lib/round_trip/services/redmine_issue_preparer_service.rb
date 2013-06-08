module RoundTrip
  class RedmineIssuePreparerService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      Ticket.for_project(project.id).not_united.with_trello.each do |t|
        t.redmine_subject = t.trello_name
        t.redmine_description = t.trello_description
        t.save!
      end
    end
  end
end

