require 'round_trip/trello/list_matcher'
require 'round_trip/services/project_synchroniser_service'

module RoundTrip
  class Synchroniser
    def run
      Project.all.each do |project|
        list_matcher = Trello::ListMatcher.new(project)
        list_map = list_matcher.list_map
        if list_map.errors.size == 0
          ProjectSynchroniserService.new(project, list_map).run
        else
          # TODO send email
        end
      end
    end
  end
end

