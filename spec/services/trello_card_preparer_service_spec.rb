require 'model_spec_helper'

module RoundTrip
  describe TrelloCardPreparerService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      include_context 'ticket project scoping'
      let(:not_united_relation) { stub('ActiveRecord::Relation not_united') }
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

      before do
        for_project_scope.stubs(:not_united).returns(not_united_relation)
        not_united_relation.stubs(:with_redmine).returns([redmine_ticket])
        redmine_ticket.stubs(:save!)
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

        expect(not_united_relation).to have_received(:with_redmine)
      end

      [
        [:redmine_subject, :trello_name, :redmine_subject_1],
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

      it 'saves' do
        subject.run

        expect(redmine_ticket).to have_received(:save!)
      end
    end
  end
end

