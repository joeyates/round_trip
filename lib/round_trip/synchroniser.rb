require 'round_trip/services/project_synchroniser_service'

module RoundTrip
  class Synchroniser
    def run
      Project.all.each do |project|
        ProjectSynchroniserService.new(project).run
      end
    end
  end
end

