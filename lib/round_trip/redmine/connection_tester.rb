module RoundTrip; end
module RoundTrip::Redmine; end

class RoundTrip::Redmine::ConnectionTester
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
  end

  def run
    RoundTrip::Redmine::Resource.setup(
      round_trip_project.config[:redmine_url],
      round_trip_project.config[:redmine_key]
    )
    RoundTrip::Redmine::Project.find(round_trip_project.config[:redmine_project_id])
    [true, "It works"]
  rescue Exception => e
    [false, "Error: #{e.message}"]
  end
end

