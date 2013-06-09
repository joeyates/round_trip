require 'model_spec_helper'

module RoundTrip
  describe RedmineIssuePreparerService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      include_context 'ticket project scoping'
      let(:not_united_relation) { stub('ActiveRecord::Relation not_united') }
      let(:trello_name_1) { 'Trello name 1' }
      let(:trello_description_1) { 'Trello description 1' }
      let(:trello_ticket) do
        create(
          :trello_ticket,
          project: project,
          trello_name: trello_name_1,
          trello_description: trello_description_1,
        )
      end
      let(:trello_id) { trello_ticket.trello_id }

      before do
        for_project_scope.stubs(:not_united).returns(not_united_relation)
        not_united_relation.stubs(:without_redmine).returns([trello_ticket])
        trello_ticket.stubs(:save!)
      end

      subject { RedmineIssuePreparerService.new(project) }

      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      it 'selects non-united tickets' do
        subject.run

        expect(for_project_scope).to have_received(:not_united)
      end

      it 'selects tickets with trello data' do
        subject.run

        expect(not_united_relation).to have_received(:without_redmine)
      end

      [
        [:trello_id,          :redmine_trello_id,   :trello_id],
        [:trello_name,        :redmine_subject,     :trello_name_1],
        [:trello_description, :redmine_description, :trello_description_1],
      ].each do |from, to, let_name|
        it "copies #{from} to #{to}" do
          value = send(let_name)

          subject.run

          expect(trello_ticket.send(to)).to eq(value)
        end

        it "leaves #{from} unchanged" do
          value = send(let_name)

          subject.run

          expect(trello_ticket.send(from)).to eq(value)
        end
      end

      it 'sets the redmine project id' do
        subject.run

        expect(trello_ticket.redmine_project_id).to eq(project.config[:redmine_project_id])
      end

      it 'saves' do
        subject.run

        expect(trello_ticket).to have_received(:save!)
      end
    end
  end
end

