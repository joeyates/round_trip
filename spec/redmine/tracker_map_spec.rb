require 'spec_helper'
require 'round_trip/redmine/tracker_map'

module RoundTrip::Redmine
  describe TrackerMap do
    let(:project) { double('Project') }
    let(:tracker_ids) { {ideas: 12345} }
    let(:trackers) do
      {
        ideas: double('Redmine::Tracker', name: 'Ideas', id: tracker_ids[:ideas])
      }
    end

    before do
      ::RoundTrip::Redmine::Tracker.stub(:all).with().and_return(trackers.values)
    end

    subject { TrackerMap.new(project) }

    it_behaves_like 'a class with constructor arity', 1

    describe '#trackers' do
      it 'lists Redmine trackers' do
        subject.trackers

        expect(::RoundTrip::Redmine::Tracker).to have_received(:all).with()
      end

      it 'returns a Hash' do
        expect(subject.trackers).to be_a(Hash)
      end

      [:ideas].each do |tracker_symbol|
        it "maps ':#{tracker_symbol}' to its tracker" do
          expect(subject.trackers[tracker_symbol]).to eq(trackers[tracker_symbol])
        end
      end
    end
  end
end

