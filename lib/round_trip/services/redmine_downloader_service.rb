require 'round_trip/models'
require 'round_trip/redmine/resource'

class RoundTrip::RedmineDownloaderService
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
    raise 'No project_id set' if project_id.nil?
  end

  def run
    RoundTrip::Ticket.where(:redmine_project_id => project_id).destroy_all
    RoundTrip::Redmine::Resource.setup(
      url,
      round_trip_project.config[:redmine_key]
    )
    issue_resources = RoundTrip::Redmine::Issue.find(:all, :params => {:project_id => project_id})
    issue_resources.each do |r|
      RoundTrip::Ticket.create_from_redmine_resource(r)
    end
    RoundTrip.logger.info "#{issue_resources.size} tickets imported from Redmine project '#{project_name}' at #{url}"
  end

  private

  def project_name
    round_trip_project.name
  end

  def project_id
    round_trip_project.config[:redmine_project_id]
  end

  def url
    round_trip_project.config[:redmine_url]
  end
end

