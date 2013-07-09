require 'active_resource'

=begin
Enable logging:
ActiveResource::Base.logger = Logger.new(STDOUT)
=end

module RoundTrip
  module Redmine; end

  class Redmine::Resource < ActiveResource::Base
    def self.setup(url, key)
      # Before requesting resources, you must set the redmine API key
      # and site URL via this method
      self.site = url
      self.headers['X-Redmine-API-Key'] = key
      nil
    end

    def self.headers
      ActiveResource::Base.headers
    end
  end

  class Redmine::Project < Redmine::Resource
    class << self
      def instantiate_collection(collection, prefix_options = {})
        issues = collection['projects']
        issues.collect! { |record| instantiate_record(record, prefix_options) }
      end
    end
  end

  class Redmine::Issue < Redmine::Resource
    class << self
      def instantiate_collection(collection, prefix_options = {})
        issues = collection['issues']
        issues.collect! { |record| instantiate_record(record, prefix_options) }
      end
    end
  end
end

