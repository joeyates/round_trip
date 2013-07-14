module RoundTrip; end

module RoundTrip::Redmine
  attr_reader :trackers

  class TrackerMap
    def initialize(project)
      @trackers = nil
    end

    def trackers
      return @trackers unless @trackers.nil?

      @trackers = ::RoundTrip::Redmine::Tracker.all.inject({}) do |a, tracker|
        a[tracker.name.downcase.intern] = tracker
        a
      end
    end
  end
end

