require 'model_spec_helper'

module RoundTrip
  describe TrelloCardCreatorService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      let(:without_trello_relation) { double('ActiveRecord::Relation') }

      before do
        for_project_scope.stub(:without_trello).and_return(without_trello_relation)
        without_trello_relation.stub(:all).and_return([])
      end

      subject { TrelloCardCreatorService.new(project) }

      include_context 'ticket project scoping'
      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      it 'selects tickets without trello ids' do
        subject.run

        expect(for_project_scope).to have_received(:without_trello)
      end

      it 'pushes tickets to trello'
      it 'includes the trello id in the description'
    end
  end
end

