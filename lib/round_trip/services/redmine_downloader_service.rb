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
      round_trip_project.config[:redmine_url],
      round_trip_project.config[:redmine_key]
    )
    issue_resources = RoundTrip::Redmine::Issue.find(:all, :params => {:project_id => project_id})
    issue_resources.each do |r|
      RoundTrip::Ticket.create_from_redmine_resource(r)
    end
  end

  private

  def project_id
    round_trip_project.config[:redmine_project_id]
  end
end

