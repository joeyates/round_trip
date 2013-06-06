require 'spec_helper'

module RoundTrip
  describe Synchroniser do
    describe '#run' do
      let(:project) { stub('Project') }
      let(:project_synchroniser) { stub('ProjectSynchroniser', :run => nil) }

      before do
        Project.stubs(:all).returns([project])
        ProjectSynchroniserService.stubs(:new).returns(project_synchroniser)
      end

      it 'loads all projects' do
        subject.run

        expect(Project).to have_received(:all)
      end

      it 'creates a project synchroniser for each project' do
        subject.run

        expect(ProjectSynchroniserService).to have_received(:new).with(project)
      end

      it 'runs the synchroniser service' do
        subject.run

        expect(project_synchroniser).to have_received(:run)
      end
    end
  end
end

