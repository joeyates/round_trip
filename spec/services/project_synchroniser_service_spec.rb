require 'model_spec_helper'

module RoundTrip
  describe ProjectSynchroniserService do
    it_behaves_like 'a class with constructor arity', 2

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
      let(:project) { double('Project', :trello => trello_config, :redmine => redmine_config) }
      let(:list_map) { double('Trello::ListMap') }
      let(:trello_downloader_service) { double('TrelloDownloaderService', :run => nil) }
      let(:redmine_downloader_service) { double('RedmineDownloaderService', :run => nil) }
      let(:ticket_merger_service) { double('TicketMergerService', :run => nil) }
      let(:matched_ticket_updater_service) { double('MatchedTicketUpdaterService', :run => nil) }
      let(:redmine_issue_preparer_service) { double('RedmineIssuePreparerService', :run => nil) }
      let(:trello_card_preparer_service) { double('TrelloCardPreparerService', :run => nil) }
      let(:redmine_issue_creator_service) { double('RedmineIssueCreatorService', run: nil) }
      let(:trello_card_creator_service) { double('TrelloCardCreatorService', run: nil) }

      subject { ProjectSynchroniserService.new(project, list_map) }

      before do
        RedmineDownloaderService.stub(:new).with(project).and_return(redmine_downloader_service)
        TrelloDownloaderService.stub(:new).with(project).and_return(trello_downloader_service)
        TicketMergerService.stub(:new).with(project).and_return(ticket_merger_service)
        MatchedTicketUpdaterService.stub(:new).with(project, list_map).and_return(matched_ticket_updater_service)
        RedmineIssuePreparerService.stub(:new).with(project).and_return(redmine_issue_preparer_service)
        TrelloCardPreparerService.stub(:new).with(project).and_return(trello_card_preparer_service)
        RedmineIssueCreatorService.stub(:new).with(project).and_return(redmine_issue_creator_service)
        TrelloCardCreatorService.stub(:new).with(project).and_return(trello_card_creator_service)
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
        expect(MatchedTicketUpdaterService).to have_received(:new).with(project, list_map)
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

      it 'creates missing redmine issues' do
        expect(RedmineIssueCreatorService).to have_received(:new).with(project)
        expect(redmine_issue_creator_service).to have_received(:run)
      end

      it 'updates existing trello issues'

      it 'creates missing trello issues' do
        expect(TrelloCardCreatorService).to have_received(:new).with(project)
        expect(trello_card_creator_service).to have_received(:run)
      end
    end
  end
end

