require 'round_trip/models'
require 'round_trip/redmine/resource'

class RoundTrip::RedmineDownloaderService
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
    raise 'No project_id set' if round_trip_project.redmine[:project_id].nil?
  end

  def run
    RoundTrip::Ticket.where(:redmine_project_id => round_trip_project.redmine[:project_id]).destroy_all
    RoundTrip::Redmine::Resource.setup(round_trip_project.redmine)
    issue_resources = RoundTrip::Redmine::Issue.find(:all, :params => {:project_id => round_trip_project.redmine[:project_id]})
    issue_resources.each do |r|
      RoundTrip::Ticket.create_from_redmine_resource(r)
    end
  end
end

