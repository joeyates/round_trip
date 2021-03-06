require 'model_spec_helper'

module RoundTrip
  describe TrelloCardPreparerService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      include_context 'ticket project scoping'
      let(:not_united_relation) { double('ActiveRecord::Relation not_united') }
      let(:redmine_subject_1) { 'Redmine subject 1' }
      let(:redmine_description_1) { 'Redmine description 1' }
      let(:redmine_ticket) do
        create(
          :redmine_ticket,
          project: project,
          redmine_subject: redmine_subject_1,
          redmine_description: redmine_description_1,
        )
      end
      let(:redmine_id) { redmine_ticket.redmine_id }

      before do
        for_project_scope.stub(:not_united).and_return(not_united_relation)
        not_united_relation.stub(:without_trello).and_return([redmine_ticket])
        redmine_ticket.stub(:save!)
      end

      subject { TrelloCardPreparerService.new(project) }

      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      it 'selects non-united tickets' do
        subject.run

        expect(for_project_scope).to have_received(:not_united)
      end

      it 'selects tickets with redmine data' do
        subject.run

        expect(not_united_relation).to have_received(:without_trello)
      end

      [
        [:redmine_id,          :trello_redmine_id,  :redmine_id],
        [:redmine_subject,     :trello_name,        :redmine_subject_1],
        [:redmine_description, :trello_description, :redmine_description_1],
      ].each do |from, to, let_name|
        it "copies #{from} to #{to}" do
          value = send(let_name)

          subject.run

          expect(redmine_ticket.send(to)).to eq(value)
        end

        it "leaves #{from} unmodified" do
          value = send(let_name)

          subject.run

          expect(redmine_ticket.send(from)).to eq(value)
        end
      end

      it 'sets the trello board id' do
        subject.run

        expect(redmine_ticket.trello_board_id).to eq(project.config[:trello_board_id])
      end

      it 'saves' do
        subject.run

        expect(redmine_ticket).to have_received(:save!)
      end
    end
  end
end

