require 'model_spec_helper'

module RoundTrip
  describe RedmineIssueCreatorService do
    it_behaves_like 'a class with constructor arity', 1

    describe '#run' do
      include_context 'ticket project scoping'
      let(:without_redmine_relation) { double('ActiveRecord::Relation') }
      let(:redmine_project_id) { generate(:redmine_project_id) }
      let(:ticket_attributes) do
        attributes_for(
          :unpushed_redmine_ticket,
          redmine_project_id: redmine_project_id
        ).merge(project: project)
      end
      let(:unpushed_redmine_ticket) { create(:ticket, ticket_attributes) }
      let(:issue_attributes) do
        {
          subject: ticket_attributes[:redmine_subject],
          description: ticket_attributes[:redmine_description],
          project_id: redmine_project_id,
        }
      end
      let(:issue) { double('ActiveResource::Base', save: nil) }

      before do
        for_project_scope.stub(:without_redmine).and_return(without_redmine_relation)
        without_redmine_relation.stub(:all).and_return([unpushed_redmine_ticket])
        Redmine::Issue.stub(:new).with(issue_attributes).and_return(issue)
      end

      subject { RedmineIssueCreatorService.new(project) }

      it 'sets up resource settings'

      it 'searches among project tickets' do
        subject.run

        expect(Ticket).to have_received(:for_project).with(project.id)
      end

      it 'selects tickets without redmine ids' do
        subject.run

        expect(for_project_scope).to have_received(:without_redmine)
      end

      it 'pushes tickets to redmine' do
        subject.run

        expect(Redmine::Issue).to have_received(:new).with(issue_attributes)
        expect(issue).to have_received(:save).with()
      end

      it 'includes the trello id in the description'
    end
  end
end

