require 'active_resource'

module RoundTrip; end
module RoundTrip::Redmine; end

=begin
Enable logging:
ActiveResource::Base.logger = Logger.new(STDOUT)
=end

class RoundTrip::Redmine::Resource < ActiveResource::Base
  def self.setup(url, key)
    # Before requesting resources, you must set the redmine API key
    # and site URL via this method
    self.site = url
    self.headers['X-Redmine-API-Key'] = key
  end

  def self.headers
    ActiveResource::Base.headers
  end
end

class RoundTrip::Redmine::Project < RoundTrip::Redmine::Resource; end
class RoundTrip::Redmine::Issue < RoundTrip::Redmine::Resource
  class << self
    def instantiate_collection(collection, prefix_options = {})
      issues = collection['issues']
      issues.collect! { |record| instantiate_record(record, prefix_options) }
    end
  end
end

