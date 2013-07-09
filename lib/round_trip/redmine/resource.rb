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

  class Redmine::Collection < ActiveResource::Collection
    attr_reader :limit
    attr_reader :offset
    attr_reader :total_count

    def self.collection_name(name)
      @collection_name = name
    end

    def initialize(parsed = {})
      collection_name = self.class.instance_variable_get('@collection_name')
      @elements    = parsed[collection_name]
      @total_count = parsed['total_count']
      @limit       = parsed['limit']
      @offset      = parsed['offset']
    end
  end

  class Redmine::ProjectCollection < Redmine::Collection
    collection_name 'projects'
  end

  class Redmine::Project < Redmine::Resource
    self.collection_parser = Redmine::ProjectCollection
  end

  class Redmine::IssueCollection < Redmine::Collection
    collection_name 'issues'
  end

  class Redmine::Issue < Redmine::Resource
    self.collection_parser = Redmine::IssueCollection
  end
end

