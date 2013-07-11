require 'spec_helper'

module RoundTrip
  describe Synchroniser do
    describe '#run' do
      let(:project) { double('Project') }
      let(:project_synchroniser) { double('ProjectSynchroniser', :run => nil) }
      let(:list_matcher) { double('ListMatcher', list_map: list_map) }
      let(:list_map) { double('ListMap', errors: []) }

      before do
        Project.stub(:all).and_return([project])
        ProjectSynchroniserService.stub(:new).and_return(project_synchroniser)
        Trello::ListMatcher.stub(:new).with(project).and_return(list_matcher)
      end

      it 'loads all projects' do
        subject.run

        expect(Project).to have_received(:all)
      end

      it 'creates a project synchroniser for each project' do
        subject.run

        expect(ProjectSynchroniserService).to have_received(:new).with(project, list_map)
      end

      it 'runs the synchroniser service' do
        subject.run

        expect(project_synchroniser).to have_received(:run)
      end
    end
  end
end

