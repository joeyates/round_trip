require 'model_spec_helper'

describe RoundTrip::ProjectSynchroniserService do
  describe '.initialize' do
    it 'expects a project'
  end

  describe '#run' do
    let(:trello_board_id) { 'aaa' }
    let(:trello_config) do
      {
        :board_id => trello_board_id
      }
    end
    let(:redmine_project_id) { 'aaa' }
    let(:redmine_config) do
      {
        :project_id => redmine_project_id
      }
    end
    let(:round_trip_project) { stub('RoundTrip::Project', :trello => trello_config, :redmine => redmine_config) }
    let(:trello_downloader_service) { stub('RoundTrip::TrelloDownloaderService', :run => nil) }
    let(:redmine_downloader_service) { stub('RoundTrip::RedmineDownloaderService', :run => nil) }

    subject { RoundTrip::ProjectSynchroniserService.new(round_trip_project) }

    before do
      RoundTrip::RedmineDownloaderService.stubs(:new).with(round_trip_project).returns(redmine_downloader_service)
      RoundTrip::TrelloDownloaderService.stubs(:new).with(round_trip_project).returns(trello_downloader_service)
      subject.run
    end

    it 'gets all redmine issues' do
      expect(RoundTrip::RedmineDownloaderService).to have_received(:new).with(round_trip_project)
      expect(redmine_downloader_service).to have_received(:run)
    end

    it 'gets all trello cards' do
      expect(RoundTrip::TrelloDownloaderService).to have_received(:new).with(round_trip_project)
      expect(trello_downloader_service).to have_received(:run)
    end

    it 'matches redmine and trello tickets'
    it 'adds unmatched redmine tickets to trello'
    it 'adds unmatched trello tickets to redmine'
    it "syncs all cards' state"
  end
end

