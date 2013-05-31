module RoundTrip; end
module RoundTrip::Redmine; end

class RoundTrip::Redmine::ConnectionTester
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def run
    RoundTrip::Redmine::Resource.headers['X-Redmine-API-Key'] = config[:key]
    RoundTrip::Redmine::Resource.site = config[:url]
    RoundTrip::Redmine::Project.find(config[:project_id])
    [true, "It works"]
  rescue Exception => e
    [false, "Error: #{e.message}"]
  end
end

