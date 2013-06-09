require 'model_spec_helper'

module RoundTrip
  describe ProjectSynchroniserService do
    it_behaves_like 'a class with constructor arity', 1

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
      let(:project) { stub('Project', :trello => trello_config, :redmine => redmine_config) }
      let(:trello_downloader_service) { stub('TrelloDownloaderService', :run => nil) }
      let(:redmine_downloader_service) { stub('RedmineDownloaderService', :run => nil) }
      let(:ticket_merger_service) { stub('TicketMergerService', :run => nil) }
      let(:matched_ticket_updater_service) { stub('MatchedTicketUpdaterService', :run => nil) }
      let(:trello_card_preparer_service) { stub('TrelloCardPreparerService', :run => nil) }
      let(:redmine_issue_preparer_service) { stub('RedmineIssuePreparerService', :run => nil) }

      subject { ProjectSynchroniserService.new(project) }

      before do
        RedmineDownloaderService.stubs(:new).with(project).returns(redmine_downloader_service)
        TrelloDownloaderService.stubs(:new).with(project).returns(trello_downloader_service)
        TicketMergerService.stubs(:new).with(project).returns(ticket_merger_service)
        MatchedTicketUpdaterService.stubs(:new).with(project).returns(matched_ticket_updater_service)
        RedmineIssuePreparerService.stubs(:new).with(project).returns(redmine_issue_preparer_service)
        TrelloCardPreparerService.stubs(:new).with(project).returns(trello_card_preparer_service)
        subject.run
      end

      it 'gets all redmine issues' do
        expect(RedmineDownloaderService).to have_received(:new).with(project)
        expect(redmine_downloader_service).to have_received(:run)
      end

      it 'gets all trello cards' do
        expect(TrelloDownloaderService).to have_received(:new).with(project)
        expect(trello_downloader_service).to have_received(:run)
      end

      it 'merges matching redmine and trello tickets' do
        expect(TicketMergerService).to have_received(:new).with(project)
        expect(ticket_merger_service).to have_received(:run)
      end

      it "syncs all matched tickets' state" do
        expect(MatchedTicketUpdaterService).to have_received(:new).with(project)
        expect(matched_ticket_updater_service).to have_received(:run)
      end

      it 'prepares missing redmine issues' do
        expect(RedmineIssuePreparerService).to have_received(:new).with(project)
        expect(redmine_issue_preparer_service).to have_received(:run)
      end

      it 'prepares missing trello cards' do
        expect(TrelloCardPreparerService).to have_received(:new).with(project)
        expect(trello_card_preparer_service).to have_received(:run)
      end

      it 'updates existing redmine issues'

      it 'create missing redmine issues' do
      end

      it 'updates existing trello issues'
      it 'create missing trello issues'
    end
  end
end

