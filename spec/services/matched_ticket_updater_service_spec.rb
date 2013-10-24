require 'model_spec_helper'

module RoundTrip
  describe MatchedTicketUpdaterService do
    it_behaves_like 'a class with constructor arity', 4

    describe '#run' do
      include_context 'ticket project scoping'
      let(:project) { create(:project) }
      let(:trello_list_map) { double('Trello::ListMap') }
      let(:redmine_trackers) { double('Redmine::Trackers') }
      let(:redmine_statuses) { double('Redmine::Statuses') }
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
      let(:trello_list) { double('Trello::List') }
      let(:idea_tracker_id) { generate(:redmine_tracker_id) }
      let(:ideas_tracker) { double('Redmine::Tracker', id: idea_tracker_id) }

      subject { MatchedTicketUpdaterService.new(project, trello_list_map, redmine_trackers, redmine_statuses) }

      before do
        for_project_scope.stub(:redmine_newer).and_return([recent_redmine])
        for_project_scope.stub(:trello_newer).and_return([recent_trello])
        recent_redmine.stub(:save!)
        recent_trello.stub(:save!)
        trello_list_map.stub(:list_for_id).and_return(trello_list)
        trello_list_map.stub(:list_to_area).with(trello_list).and_return(:ideas)
        redmine_trackers.stub(:area_to_tracker).with(:ideas).and_return(ideas_tracker)
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

        context 'Redmine issue is' do
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

        it 'gets the Trello list' do
          subject.run

          expect(trello_list_map).to have_received(:list_for_id).with(recent_trello.trello_list_id)
        end

        it 'gets the area for the Trello list' do
          subject.run

          expect(trello_list_map).to have_received(:list_to_area).with(trello_list)
        end

        context 'Trello card is in' do
          context 'ideas' do
            before do
              trello_list_map.stub(:list_to_area).with(trello_list).and_return(:ideas)
            end

            it "sets the tracker to 'Idea'" do
              subject.run

              expect(recent_trello.redmine_tracker_id).to eq(idea_tracker_id)
            end

            it 'sets the status to new'
            it 'unsets the version'
          end

          context 'backlog' do
            let(:feature_tracker_id) { generate(:redmine_tracker_id) }
            let(:feature_tracker) { double('Redmine::Tracker', id: feature_tracker_id) }

            before do
            end

            it "sets the tracker to 'Feature' if it is set to 'Idea'" do
              subject.run

              expect(recent_trello.redmine_tracker_id).to eq(feature_tracker_id)
            end

            it "leaves the tracker unchanged if it is set to 'Bug'"

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

        it 'saves changes' do
          subject.run

          expect(recent_redmine).to have_received(:save!)
          expect(recent_trello).to have_received(:save!)
        end
      end
    end
  end
end

