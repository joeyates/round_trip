shared_context 'ticket project scoping' do
  let(:project_attributes) { attributes_for(:project) }
  let(:project) { create(:project, project_attributes) }
  let(:for_project_scope) { double('ActiveRecord::Relation Ticket.for_project scope') }

  before do
    RoundTrip::Ticket.stub(:for_project).with(project.id).and_return(for_project_scope)
  end
end

