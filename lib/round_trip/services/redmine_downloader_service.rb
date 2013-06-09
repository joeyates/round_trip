require 'round_trip/models'
require 'round_trip/redmine/resource'

module RoundTrip
  class RedmineDownloaderService
    attr_reader :project

    def initialize(project)
      @project = project
      raise 'No project_id set' if project_id.nil?
    end

    def run
      Ticket.where(:redmine_project_id => project_id).destroy_all
      Redmine::Resource.setup(
        url,
        project.config[:redmine_key]
      )
      issue_resources = Redmine::Issue.find(:all, :params => {:project_id => project_id})
      issue_resources.each do |r|
        Ticket.create_from_redmine_resource(project, r)
      end
      RoundTrip.logger.info "#{issue_resources.size} tickets imported from Redmine project #{project_id} at #{url}"
    end

    private

    def project_id
      project.config[:redmine_project_id]
    end

    def url
      project.config[:redmine_url]
    end
  end
end

