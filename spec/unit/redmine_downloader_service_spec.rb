require 'model_spec_helper'

describe RoundTrip::RedmineDownloaderService do
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
  let(:round_trip_project) { stub('RoundTrip::Project', :config => project_config) }
  let(:tickets_relation) { stub('ActiveRecord::Relation', :destroy_all => nil) }
  let(:issue_find_params) do
    [:all, :params => {:project_id => redmine_project_id}]
  end
  let(:resource_attribs) do
    {
      :id => 123,
      :project => stub('RoundTrip::Redmine::Issue', :id => redmine_project_id),
      :updated_on => '2013/05/17 18:15:28 +0200',
      :subject => 'The Subject',
      :description => 'The description',
    }
  end
  let(:issue_resource) { stub('RoundTrip::Redmine::Issue', resource_attribs) }
  let(:ticket_attributes) do
    {
      :redmine_id => 123,
      :redmine_project_id => redmine_project_id,
      :redmine_updated_on => '2013/05/17 18:15:28 +0200',
      :redmine_subject => 'The Subject',
      :redmine_description => 'The description',
    }
  end

  describe '.initialize' do
    it 'expects a round_trip project'
  end

  describe '#run' do
    subject { RoundTrip::RedmineDownloaderService.new(round_trip_project) }

    before do
      RoundTrip::Ticket.stubs(:where).with(:redmine_project_id => redmine_project_id).returns(tickets_relation)
      RoundTrip::Ticket.stubs(:create!).with(anything)
      RoundTrip::Redmine::Resource.stubs(:setup).with(redmine_url, redmine_key)
      RoundTrip::Redmine::Issue.stubs(:find).with(*issue_find_params).returns([issue_resource])
      subject.run
    end

    it 'clears all previous tickets for the board' do
      expect(RoundTrip::Ticket).to have_received(:where).with(:redmine_project_id => redmine_project_id)
      expect(tickets_relation).to have_received(:destroy_all)
    end

    it 'sets up the redmine resources' do
      expect(RoundTrip::Redmine::Resource).to have_received(:setup).with(redmine_url, redmine_key)
    end

    it 'downloads the issues' do
      expect(RoundTrip::Redmine::Issue).to have_received(:find).with(*issue_find_params)
    end

    it 'creates tickets' do
      expect(RoundTrip::Ticket).to have_received(:create!).with(ticket_attributes)
    end
  end
end

