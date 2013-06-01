require 'round_trip/services/project_synchroniser_service'

module RoundTrip; end

class RoundTrip::Synchroniser
  def run
    RoundTrip::Project.all.each do |project|
      service = RoundTrip::ProjectSynchroniserService.new(project)
      service.run
    end
  end
end

