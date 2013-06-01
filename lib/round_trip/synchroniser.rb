require 'round_trip/services/project_synchroniser_service'

module RoundTrip; end

class RoundTrip::Synchroniser
  def run
    RoundTrip::Project.all.each do |project|
      RoundTrip::ProjectSynchroniserService.new(project).run
    end
  end
end

