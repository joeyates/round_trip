require 'round_trip/models'
require 'round_trip/services/redmine_downloader_service'
require 'round_trip/services/trello_downloader_service'
require 'round_trip/services/ticket_merger_service'
require 'round_trip/services/matched_ticket_updater_service'

module RoundTrip
  class ProjectSynchroniserService
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      RedmineDownloaderService.new(project).run
      TrelloDownloaderService.new(project).run
      TicketMergerService.new(project).run
      MatchedTicketUpdaterService.new(project).run
    end
  end
end

