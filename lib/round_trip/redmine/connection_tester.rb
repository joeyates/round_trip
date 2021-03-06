require 'round_trip/redmine/resource'

module RoundTrip
  module Redmine; end

  class Redmine::ConnectionTester
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      RoundTrip::Redmine::Resource.setup(
        project.config[:redmine_url],
        project.config[:redmine_key]
      )
      RoundTrip::Redmine::Project.find(project.config[:redmine_project_id])
      [true, "It works"]
    rescue Exception => e
      [false, "Error: #{e.message}"]
    end
  end
end

