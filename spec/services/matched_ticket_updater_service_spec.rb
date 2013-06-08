require 'model_spec_helper'

module RoundTrip
  describe MatchedTicketUpdaterService do
    describe '.initialize' do
      it 'expects a project' do
        expect {
          MatchedTicketUpdaterService.new
        }.to raise_error(ArgumentError, 'wrong number of arguments (0 for 1)')
      end
    end

    describe '#run' do
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
        Ticket.stubs(:redmine_newer).returns([recent_redmine])
        Ticket.stubs(:trello_newer).returns([recent_trello])
        recent_redmine.stubs(:save!)
        recent_trello.stubs(:save!)
      end

      context 'where redmine is more recent' do
        it 'finds tickets' do
          subject.run

          expect(Ticket).to have_received(:redmine_newer).with(project.id)
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
      end

      context 'where trello is more recent' do
        it 'finds tickets' do
          subject.run

          expect(Ticket).to have_received(:trello_newer).with(project.id)
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
      end
    end
  end
end

