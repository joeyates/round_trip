module RoundTrip; end

module RoundTrip::Redmine
  class TrackerMap
    attr_reader :project
    attr_reader :trackers

    def initialize(project)
      @project = project
      @trackers = nil
    end

    def trackers
      return @trackers unless @trackers.nil?

      RoundTrip::Redmine::Resource.setup(project.config[:redmine_url], project.config[:redmine_key])
      @trackers = ::RoundTrip::Redmine::Tracker.all.inject({}) do |a, tracker|
        a[tracker.name.downcase.intern] = tracker
        a
      end
    end
  end
end

