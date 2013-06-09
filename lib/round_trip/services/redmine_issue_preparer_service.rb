module RoundTrip
  class RedmineIssuePreparerService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      Ticket.for_project(project.id).not_united.without_redmine.each do |t|
        t.redmine_trello_id    = t.trello_id
        t.redmine_subject      = t.trello_name
        t.redmine_description  = t.trello_description
        t.redmine_project_id   = project.config[:redmine_project_id]
        t.save!
      end
    end
  end
end

