require 'round_trip/models'
require 'round_trip/services/redmine_downloader_service'
require 'round_trip/services/trello_downloader_service'
require 'round_trip/services/ticket_matcher_service'

class RoundTrip::ProjectSynchroniserService
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def run
    RoundTrip::RedmineDownloaderService.new(project).run
    RoundTrip::TrelloDownloaderService.new(project).run
    RoundTrip::TicketMatcherService.new(project).run
  end
end

