require 'model_spec_helper'

module RoundTrip
  describe RedmineAccount do
    let(:redmine_url) { generate(:redmine_url) }
    let(:redmine_key) { generate(:redmine_key) }
    let(:config) { {redmine_url: redmine_url, redmine_key: redmine_key} }
    let(:projects) { [ stub('Redmine::Project') ] }

    subject { create(:redmine_account, config: config) }

    describe'#projects' do
      before do
        Redmine::Resource.stubs(:setup)
        Redmine::Project.stubs(:all).returns(projects)
      end

      it 'sets up the resource' do
        subject.projects

        expect(Redmine::Resource).to have_received(:setup).with(redmine_url, redmine_key)
      end

      it 'gets all projects' do
        subject.projects

        expect(Redmine::Project).to have_received(:all).with()
      end

      it 'returns the projects' do
        expect(subject.projects).to eq(projects)
      end
    end
  end
end

