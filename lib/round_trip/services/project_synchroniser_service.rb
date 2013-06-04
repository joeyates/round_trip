require 'round_trip/models'
require 'round_trip/services/redmine_downloader_service'
require 'round_trip/services/trello_downloader_service'
require 'round_trip/services/ticket_merger_service'
require 'round_trip/services/matched_ticket_updater_service'

class RoundTrip::ProjectSynchroniserService
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def run
    RoundTrip::RedmineDownloaderService.new(project).run
    RoundTrip::TrelloDownloaderService.new(project).run
    RoundTrip::TicketMergerService.new(project).run
    RoundTrip::MatchedTicketUpdaterService.new(project).run
  end
end

