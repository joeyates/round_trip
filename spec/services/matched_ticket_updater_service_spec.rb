require 'model_spec_helper'

module RoundTrip
  describe MatchedTicketUpdaterService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      include_context 'ticket project scoping'
      let(:project) { create(:project) }
      let(:old) { 10.days.ago }
      let(:new) { 2.days.ago }
      let(:redmine_subject_1) { 'Redmine subject 1' }
      let(:redmine_description_1) { 'Redmine description 1' }
      let(:trello_name_1) { 'Trello name 1' }
      let(:trello_description_1) { 'Trello description 1' }
      let(:redmine_subject_2) { 'Redmine subject 2' }
      let(:redmine_description_2) { 'Redmine description 2' }
      let(:trello_name_2) { 'Trello name 2' }
      let(:trello_description_2) { 'Trello description 2' }
      let(:recent_redmine) do
        create(
          :united_ticket,
          redmine_updated_on: new,
          trello_last_activity_date: old,
          redmine_subject: redmine_subject_1,
          redmine_description: redmine_description_1,
          trello_name: trello_name_1,
          trello_description: trello_description_1,
          project: project
        )
      end
      let(:recent_trello) do
        create(
          :united_ticket,
          redmine_updated_on: old,
          trello_last_activity_date: new,
          redmine_subject: redmine_subject_2,
          redmine_description: redmine_description_2,
          trello_name: trello_name_2,
          trello_description: trello_description_2,
          project: project
        )
      end

      subject { MatchedTicketUpdaterService.new(project) }

      before do
        for_project_scope.stubs(:redmine_newer).returns([recent_redmine])
        for_project_scope.stubs(:trello_newer).returns([recent_trello])
        recent_redmine.stubs(:save!)
        recent_trello.stubs(:save!)
      end

      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      context 'where redmine is more recent' do
        it 'finds tickets' do
          subject.run

          expect(for_project_scope).to have_received(:redmine_newer)
        end

        [
          [:trello_name, :redmine_subject, :redmine_subject_1],
          [:trello_description, :redmine_description, :redmine_description_1],
        ].each do |from, to, let_name|
          it "copies #{from} to #{to}" do
            value = send(let_name)

            subject.run

            expect(recent_redmine.send(to)).to eq(value)
          end

          it "leaves #{from} unchanged" do
            value = send(let_name)

            subject.run

            expect(recent_redmine.send(from)).to eq(value)
          end
        end

        context 'ticket is in' do
          context 'ideas' do
            it "sets the tracker to 'Idea'"
            it 'sets the status to new'
            it 'unsets the version'
          end

          context 'backlog' do
            it "sets the tracker to 'Feature' if it is set to 'Idea'"
            it 'sets the status to new'
            it 'unsets the version'
          end

          context 'current' do
            it "sets the tracker to 'Feature' if it is set to 'Idea'"
            it 'sets the status to new'
            it "sets the version to 'Sprint nn'"
          end

          context 'unmatched list' do
            it "sets the tracker to 'Feature' if it is set to 'Idea'"
            it "sets the status to 'in progress'"
            it "sets the version to 'Sprint nn'"
          end

          context 'done' do
            it "sets the status to 'feedback'"
            it "sets the version to 'Sprint nn'"
          end

          context 'archived' do
            it "sets the status to 'closed'"
          end
        end
      end

      context 'where trello is more recent' do
        it 'finds tickets' do
          subject.run

          expect(for_project_scope).to have_received(:trello_newer)
        end

        [
          [:trello_name, :redmine_subject, :trello_name_2],
          [:trello_description, :redmine_description, :trello_description_2],
        ].each do |from, to, let_name|
          it "copies #{from} to #{to}" do
            value = send(let_name)

            subject.run

            expect(recent_trello.send(to)).to eq(value)
          end

          it "leaves #{from} unchanged" do
            value = send(let_name)

            subject.run

            expect(recent_trello.send(from)).to eq(value)
          end
        end

        it 'saves changes' do
          subject.run

          expect(recent_redmine).to have_received(:save!)
          expect(recent_trello).to have_received(:save!)
        end

        context 'issue is' do
          context "in 'ideas' tracker" do
            it "sets the list to 'ideas'"
          end

          context 'new issue, no version' do
            it "sets the list to 'backlog'"
          end

          context 'new issue, current version' do
            it "sets the list to 'current'"
          end

          context 'in progress, current version' do
            context 'unmatched lists exist' do
              it "sets puts the card in the first unmatched, non-archived list"
            end

            context 'no unmatched lists exist' do
              it "creates a list called 'In progress'"
              it 'puts the card in the new list'
            end
          end

          context 'feedback, current version' do
            it "puts the card in the 'done' list"
          end

          context 'closed' do
            it "creates an archived list for the current sprint"
            it 'puts the card in the archived list'
          end
        end
      end
    end
  end
end

