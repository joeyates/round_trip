require 'round_trip/redmine/resource'

module RedmineStubs
  include RSpec::Mocks::ArgumentMatchers

  FAKE_INSTALLATIONS = {
    good:             'http://example.com',
    no_ideas_tracker: 'http://no.ideas.com/',
  }

  def stub_redmine
    RoundTrip::Redmine::Resource.instance_eval do
      def setup(redmine_url, redmine_key)
        # set up trackers according to the supplied URL
        @ideas_tracker = stub('Tracker')
        @ideas_tracker.stub(:name).and_return('Ideas')
        @ideas_tracker.stub(:id).and_return(99999)

        @other_tracker = stub('Tracker')
        @other_tracker.stub(:name).and_return('Other')
        @other_tracker.stub(:id).and_return(8888)

        case redmine_url
        when FAKE_INSTALLATIONS[:good]
          RoundTrip::Redmine::Tracker.stub(:all).with().and_return([@ideas_tracker])
        when FAKE_INSTALLATIONS[:no_ideas_tracker]
          RoundTrip::Redmine::Tracker.stub(:all).with().and_return([@other_tracker])
        else
          raise 'Supply a known Redmine URL'
        end
      end
    end

    @redmine_project = stub('Project')
    @redmine_project.stub(:name).and_return('My project')
    @redmine_project.stub(:id).and_return('12345')

    @redmine_no_ideas_project = stub('Project')
    @redmine_no_ideas_project.stub(:name).and_return('No ideas project')
    @redmine_no_ideas_project.stub(:id).and_return(23456)

    RoundTrip::Redmine::Project.stub(:all).with().and_return([@redmine_project])
    RoundTrip::Redmine::Project.stub(:find).with(anything).and_return([@redmine_project])
  end
end

