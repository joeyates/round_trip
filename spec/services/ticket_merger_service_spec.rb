require 'model_spec_helper'

module RoundTrip
  describe TicketMergerService do
    describe '#run' do
      let(:attributes) { attributes_for(:project) }
      let(:project) { create(:project, attributes) }
      let(:redmine_project_id) { attributes[:config][:redmine_project_id] }
      let(:trello_board_id) { attributes[:config][:trello_board_id] }

      subject { TicketMergerService.new(project) }

      before do
        Ticket.stubs(:check_repeated_redmine_ids).with(redmine_project_id)
        Ticket.stubs(:check_repeated_trello_ids).with(trello_board_id)
      end

      context 'config checks' do
        [:redmine_project_id, :redmine_url, :trello_board_id].each do |key|
          name = key.to_s.gsub('_', ' ')
          it "expects a #{name}" do
            partial = attributes[:config].clone
            partial.delete(key)
            project = stub('Project', :config => partial)
            subject = TicketMergerService.new(project)

            expect {
              subject.run
            }.to raise_error(RuntimeError, "#{name} not set")
          end
        end
      end

      context 'preliminary checks' do
        before do
          subject.run
        end

        it 'checks if there are duplicate redmine issue ids' do
          expect(Ticket).to have_received(:check_repeated_redmine_ids).with(redmine_project_id)
        end

        it 'checks if there are repeated trello card ids' do
          expect(Ticket).to have_received(:check_repeated_trello_ids).with(trello_board_id)
        end

        it 'checks if there are duplicate titles'
      end

      context 'where trello id is in redmine issue' do
        it 'requests suitable tickets'
        it 'extracts un-united tickets'
        it 'merges the trello data into the redmine ticket'
      end

      context 'where redmine id is in trello card' do
        let(:redmine_issue_id) { 12345 }
        let(:trello_ticket) { stub('Ticket (trello)', :trello_redmine_id => redmine_issue_id, :merge_redmine => nil, :save! => nil) }
        let(:redmine_ticket) { stub('Ticket (redmine)') }
        let(:trello_has_redmine_id_relation) { stub('ActiveRecord::Relation', :not_united => not_united_relation) }
        let(:not_united_relation) { stub('ActiveRecord::Relation', :all => [trello_ticket]) }

        subject { TicketMergerService.new(project) }

        before do
          Ticket.stubs(:trello_has_redmine_id).returns(trello_has_redmine_id_relation)
          Ticket.stubs(:find).with(redmine_issue_id).returns(redmine_ticket)
        end

        it 'requests suitable tickets' do
          subject.run

          expect(Ticket).to have_received(:trello_has_redmine_id)
        end

        it 'extracts un-united tickets' do
          subject.run

          expect(trello_has_redmine_id_relation).to have_received(:not_united)
        end

        it 'fails if the matching redmine issue is missing' do
          Ticket.stubs(:find).with(redmine_issue_id).raises('not found')

          expect {
            subject.run
          }.to raise_error
        end

        it 'merges the redmine data into the trello ticket' do
          subject.run

          expect(trello_ticket).to have_received(:merge_redmine).with(redmine_ticket)
        end
      end

      context 'titles match' do
        it 'requests suitable tickets'
        it 'extracts un-united tickets'
        it 'merges the trello data into the redmine ticket'
      end
    end
  end
end

