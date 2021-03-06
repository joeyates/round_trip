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
        t.stub(:merge_trello)
        t.stub(:save!)
        t
      end
      let(:redmine_ticket_merged_to_trello) { create(:redmine_ticket, project: project) }
      let(:trello_ticket) do
        t = create(:trello_ticket, trello_redmine_id: redmine_ticket_merged_to_trello.redmine_id, project: project)
        t.stub(:merge_redmine)
        t.stub(:save!)
        t
      end
      let(:not_united_relation) { double('ActiveRecord::Relation for project, not united') }
      let(:not_united_without_redmine_relation) { double('ActiveRecord::Relation for project, not united, without redmine') }
      let(:redmine_has_trello_id_relation) { double('ActiveRecord::Relation', :all => [redmine_ticket]) }
      let(:trello_has_redmine_id_relation) { double('ActiveRecord::Relation', :all => [trello_ticket]) }

      subject { TicketMergerService.new(project) }

      before do
        trello_ticket
        Ticket.stub(:check_repeated_redmine_ids).with(redmine_project_id)
        Ticket.stub(:check_repeated_trello_ids).with(trello_board_id)
        Ticket.stub(:check_repeated_redmine_subjects).with(redmine_project_id)
        Ticket.stub(:check_repeated_trello_names).with(trello_board_id)
        Ticket.stub(:where).with(redmine_id: redmine_ticket_merged_to_trello.redmine_id).and_return([redmine_ticket_merged_to_trello])
        Ticket.stub(:where).with(trello_id: trello_ticket_merged_to_redmine.trello_id).and_return([trello_ticket_merged_to_redmine])
        Ticket.stub(:redmine_subject_with_matching_trello_name).with(project).and_return([])
        for_project_scope.stub(:not_united).and_return(not_united_relation)
        not_united_relation.stub(:redmine_has_trello_id).and_return(redmine_has_trello_id_relation)
        not_united_relation.stub(:trello_has_redmine_id).and_return(trello_has_redmine_id_relation)
      end

      context 'config checks' do
        [:redmine_project_id, :trello_board_id].each do |key|
          name = key.to_s.gsub('_', ' ')
          it "expects a #{name}" do
            partial = project_attributes[:config].clone
            partial.delete(key)
            project = double('Project', :config => partial)
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

        it 'checks if there are duplicate redmine subjects' do
          expect(Ticket).to have_received(:check_repeated_redmine_subjects).with(redmine_project_id)
        end

        it 'checks if there are duplicate trello names' do
          expect(Ticket).to have_received(:check_repeated_trello_names).with(trello_board_id)
        end
      end

      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      it 'extracts un-united tickets' do
        subject.run

        expect(for_project_scope).to have_received(:not_united)
      end

      context 'where redmine issue has trello id' do
        it 'requests suitable tickets' do
          subject.run

          expect(not_united_relation).to have_received(:redmine_has_trello_id)
        end

        it 'fails if the matching trello ticket is missing' do
          Ticket.stub(:where).with(trello_id: trello_ticket_merged_to_redmine.trello_id).and_raise(ActiveRecord::RecordNotFound)

          expect {
            subject.run
          }.to raise_error
        end

        it 'merges the trello data into the redmine ticket' do
          subject.run

          expect(redmine_ticket).to have_received(:merge_trello).with(trello_ticket_merged_to_redmine)
        end
      end

      context 'where trello card has redmine id' do
        it 'requests suitable tickets' do
          subject.run

          expect(not_united_relation).to have_received(:trello_has_redmine_id)
        end

        it 'fails if the matching redmine issue is missing' do
          Ticket.stub(:where).with(redmine_id: redmine_ticket_merged_to_trello.redmine_id).and_raise(ActiveRecord::RecordNotFound)

          expect {
            subject.run
          }.to raise_error
        end

        it 'merges the redmine data into the trello ticket' do
          subject.run

          expect(trello_ticket).to have_received(:merge_redmine).with(redmine_ticket_merged_to_trello)
        end
      end

      context 'titles match' do
        let(:matching_title) { 'Matching Title' }
        let(:redmine_ticket_with_matching_title) { create(:redmine_ticket, project: project, redmine_subject: matching_title) }
        let(:trello_ticket_with_matching_title) { create(:trello_ticket, project: project, trello_name: matching_title) }

        before do
          Ticket.stub(:redmine_subject_with_matching_trello_name).with(project).and_return([redmine_ticket_with_matching_title])
          not_united_relation.stub(:without_redmine).and_return(not_united_without_redmine_relation)
          not_united_without_redmine_relation.stub_chain(:where, :first).and_return(trello_ticket_with_matching_title)
          redmine_ticket_with_matching_title.stub(:merge_trello).with(trello_ticket_with_matching_title)
        end

        it 'requests suitable tickets' do
          subject.run

          expect(Ticket).to have_received(:redmine_subject_with_matching_trello_name).with(project)
        end

        it 'merges the trello data into the redmine ticket' do
          subject.run

          expect(redmine_ticket_with_matching_title).to have_received(:merge_trello).with(trello_ticket_with_matching_title)
        end
      end
    end
  end
end

