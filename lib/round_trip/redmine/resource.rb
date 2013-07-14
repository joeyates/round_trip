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

    # Unroll pagination
    def self.all(params = {})
      ps = self.find(:all, params: params)
      total_count = ps.total_count
      limit = ps.limit
      ps = ps.to_a
      if ps.size < total_count
        (limit .. total_count).step(limit) do |offset|
          ps += self.find(:all, params: params.merge({offset: offset, limit: limit})).to_a
        end
      end
      ps
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

  class Redmine::TrackerCollection < Redmine::Collection
    collection_name 'trackers'
  end

  class Redmine::Tracker < Redmine::Resource
    self.collection_parser = Redmine::TrackerCollection
  end
end

