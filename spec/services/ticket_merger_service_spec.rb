require 'model_spec_helper'

module RoundTrip
  describe TicketMergerService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      include_context 'ticket project scoping'
      let(:redmine_project_id) { project_attributes[:config][:redmine_project_id] }
      let(:trello_board_id) { project_attributes[:config][:trello_board_id] }
      let(:trello_ticket_merged_to_redmine) { create(:trello_ticket, project: project) }
      let(:redmine_ticket) do
        t = create(:redmine_ticket, redmine_trello_id: trello_ticket_merged_to_redmine.trello_id, project: project)
        t.stubs(:merge_redmine)
        t.stubs(:save!)
        t
      end
      let(:redmine_ticket_merged_to_trello) { create(:redmine_ticket, project: project) }
      let(:trello_ticket) do
        t = create(:trello_ticket, trello_redmine_id: redmine_ticket_merged_to_trello.redmine_id, project: project)
        t.stubs(:merge_redmine)
        t.stubs(:save!)
        t
      end
      let(:not_united_relation) { stub('ActiveRecord::Relation') }
      let(:redmine_has_trello_id_relation) { stub('ActiveRecord::Relation', :all => [redmine_ticket]) }
      let(:trello_has_redmine_id_relation) { stub('ActiveRecord::Relation', :all => [trello_ticket]) }

      subject { TicketMergerService.new(project) }

      before do
        trello_ticket
        Ticket.stubs(:check_repeated_redmine_ids).with(redmine_project_id)
        Ticket.stubs(:check_repeated_trello_ids).with(trello_board_id)
        Ticket.stubs(:where).with(redmine_id: redmine_ticket_merged_to_trello.redmine_id).returns([redmine_ticket_merged_to_trello])
        Ticket.stubs(:where).with(trello_id: trello_ticket_merged_to_redmine.trello_id).returns([trello_ticket_merged_to_redmine])
        for_project_scope.stubs(:not_united).returns(not_united_relation)
        not_united_relation.stubs(:redmine_has_trello_id).returns(redmine_has_trello_id_relation)
        not_united_relation.stubs(:trello_has_redmine_id).returns(trello_has_redmine_id_relation)
      end

      context 'config checks' do
        [:redmine_project_id, :trello_board_id].each do |key|
          name = key.to_s.gsub('_', ' ')
          it "expects a #{name}" do
            partial = project_attributes[:config].clone
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

      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      context 'where trello id is in redmine issue' do
        it 'extracts un-united tickets' do
          subject.run

          expect(for_project_scope).to have_received(:not_united)
        end

        it 'requests suitable tickets' do
          subject.run

          expect(not_united_relation).to have_received(:redmine_has_trello_id)
        end

        it 'fails if the matching trello ticket is missing'
        it 'merges the trello data into the redmine ticket'
        it 'deletes the trello ticket'
      end

      context 'where redmine id is in trello card' do
        it 'extracts un-united tickets' do
          subject.run

          expect(for_project_scope).to have_received(:not_united)
        end

        it 'requests suitable tickets' do
          subject.run

          expect(not_united_relation).to have_received(:trello_has_redmine_id)
        end

        it 'fails if the matching redmine issue is missing' do
          Ticket.stubs(:where).with(redmine_id: redmine_ticket_merged_to_trello.redmine_id).raises(ActiveRecord::RecordNotFound)

          expect {
            subject.run
          }.to raise_error
        end

        it 'merges the redmine data into the trello ticket' do
          subject.run

          expect(trello_ticket).to have_received(:merge_redmine).with(redmine_ticket_merged_to_trello)
        end

        it 'deletes the redmine ticket'
      end

      context 'titles match' do
        it 'requests suitable tickets'
        it 'extracts un-united tickets'
        it 'merges the trello data into the redmine ticket'
        it 'deletes the trello ticket'
      end
    end
  end
end

