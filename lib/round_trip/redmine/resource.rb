require 'active_resource'

module RoundTrip; end
module RoundTrip::Redmine; end

class RoundTrip::Redmine::Resource < ActiveResource::Base
  # You must set
  # * RoundTrip::Redmine::Resource.headers['X-Redmine-API-Key']
  # * RoundTrip::Redmine::Resource.site

  def self.headers
    ActiveResource::Base.headers
  end
end

class RoundTrip::Redmine::Project < RoundTrip::Redmine::Resource; end

