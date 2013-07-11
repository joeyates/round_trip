require 'model_spec_helper'

module RoundTrip
  describe RedmineDownloaderService do
    it_behaves_like 'a class with constructor arity', 1

    let(:redmine_project_id) { 12345 }
    let(:redmine_url) { 'http://example.com' }
    let(:redmine_key) { 'aaaa' }
    let(:project_config) do
      {
        :redmine_project_id => redmine_project_id,
        :redmine_url => redmine_url,
        :redmine_key => redmine_key,
      }
    end
    let(:project) { double('Project', :config => project_config) }
    let(:tickets_relation) { double('ActiveRecord::Relation', :destroy_all => nil) }
    let(:issue_find_params) do
      [:all, :params => {:project_id => redmine_project_id}]
    end
    let(:issue_resource) { double('Redmine::Issue') }

    describe '#run' do
      subject { RedmineDownloaderService.new(project) }

      before do
        Ticket.stub(:where).with(:redmine_project_id => redmine_project_id).and_return(tickets_relation)
        Redmine::Resource.stub(:setup).with(redmine_url, redmine_key)
        Redmine::Issue.stub(:find).with(*issue_find_params).and_return([issue_resource])
        Ticket.stub(:create_from_redmine_resource).with(project, issue_resource)
        subject.run
      end

      it 'clears all previous tickets for the board' do
        expect(Ticket).to have_received(:where).with(:redmine_project_id => redmine_project_id)
        expect(tickets_relation).to have_received(:destroy_all)
      end

      it 'sets up the redmine resources' do
        expect(Redmine::Resource).to have_received(:setup).with(redmine_url, redmine_key)
      end

      it 'downloads the issues' do
        expect(Redmine::Issue).to have_received(:find).with(*issue_find_params)
      end

      it 'creates tickets' do
        expect(Ticket).to have_received(:create_from_redmine_resource).with(project, issue_resource)
      end
    end
  end
end

