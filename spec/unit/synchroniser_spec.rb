require 'spec_helper'

describe RoundTrip::Synchroniser do
  describe '#run' do
    let(:project) { stub('RoundTrip::Project') }
    let(:project_synchroniser) { stub('RoundTrip::ProjectSynchroniser', :run => nil) }

    before do
      RoundTrip::Project.stubs(:all).returns([project])
      RoundTrip::ProjectSynchroniserService.stubs(:new).returns(project_synchroniser)
    end

    it 'loads all projects' do
      subject.run

      expect(RoundTrip::Project).to have_received(:all)
    end

    it 'creates a project synchroniser for each project' do
      subject.run

      expect(RoundTrip::ProjectSynchroniserService).to have_received(:new).with(project)
    end

    it 'runs the synchroniser service' do
      subject.run

      expect(project_synchroniser).to have_received(:run)
    end
  end
end

