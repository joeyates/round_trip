require 'round_trip/redmine/resource'

module RoundTrip
  class RedmineIssueCreatorService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      Redmine::Resource.setup(url, project.config[:redmine_key])
      Ticket.for_project(project.id).without_redmine.all.each do |t|
        attributes = issue_attributes(t)
        issue = Redmine::Issue.new(attributes)
        issue.save
      end
    end
    
    private

    def issue_attributes(ticket)
      {
        subject: ticket.redmine_subject,
        description: ticket.redmine_description,
        project_id: ticket.redmine_project_id,
      }
    end

    def url
      project.config[:redmine_url]
    end
  end
end

