require 'round_trip/redmine/resource'

module RedmineStubs
  extend RSpec::Mocks::ArgumentMatchers

  RoundTrip::Redmine::Resource.
    stub(:setup).
    with(anything, anything)
  @redmine_project = stub('Project')
  @redmine_project.stub(:name).and_return('My project')
  @redmine_project.stub(:id).and_return('12345')
  RoundTrip::Redmine::Project.stub(:all).with().and_return([@redmine_project])
  RoundTrip::Redmine::Project.stub(:find).with(anything).and_return([@redmine_project])
end

