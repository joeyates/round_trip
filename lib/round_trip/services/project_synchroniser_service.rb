require 'round_trip/models'
require 'round_trip/services/redmine_downloader_service'
require 'round_trip/services/trello_downloader_service'
require 'round_trip/services/ticket_merger_service'
require 'round_trip/services/matched_ticket_updater_service'
require 'round_trip/services/redmine_issue_preparer_service'
require 'round_trip/services/trello_card_preparer_service'
require 'round_trip/services/redmine_issue_creator_service'
require 'round_trip/services/trello_card_creator_service'

module RoundTrip
  class ProjectSynchroniserService
    attr_reader :project
    attr_reader :list_map

    def initialize(project, list_map)
      @project, @list_map = project, list_map
    end

    def run
      RedmineDownloaderService.new(project).run
      TrelloDownloaderService.new(project).run
      TicketMergerService.new(project).run
      MatchedTicketUpdaterService.new(project, list_map).run
      RedmineIssuePreparerService.new(project).run
      TrelloCardPreparerService.new(project).run
      RedmineIssueCreatorService.new(project).run
      TrelloCardCreatorService.new(project).run
    end
  end
end

