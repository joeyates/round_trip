require 'model_spec_helper'

describe RoundTrip::TicketMatcherService do
  describe '#run' do
    let(:attributes) do
      {
        :redmine_project_id => 'a',
        :redmine_url => 'b',
        :trello_board_id => 'c',
      }
    end
    let(:round_trip_project) { stub('RoundTrip::Project', :config => attributes) }

    subject { RoundTrip::TicketMatcherService.new(round_trip_project) }

    context 'config checks' do
      [:redmine_project_id, :redmine_url, :trello_board_id].each do |key|
        name = key.to_s.gsub('_', ' ')
        it "expects a #{name}" do
          partial = attributes.clone
          partial.delete(key)
          round_trip_project = stub('RoundTrip::Project', :config => partial)
          subject = RoundTrip::TicketMatcherService.new(round_trip_project)

          expect {
            subject.run
          }.to raise_error(RuntimeError, "#{name} not set")
        end
      end
    end

    context 'redmine id is in trello card, but not vice versa' do
      it 'requests suitable tickets'
      it 'only checks un-united tickets'
      it 'fails if the id is in more than one trello card'
      it 'unites the cards'
      it 'puts the trello id in the description'
      it 'marks for redmine and trello update'
    end

    context 'trello id is in redmine issue, but not vice versa' do
      it 'requests suitable tickets'
      it 'only checks un-united tickets'
      it 'fails if the trello id is in more than one redmine issue'
      it 'unites the cards'
      it 'puts the redmine id in the description'
      it 'marks for redmine and trello update'
    end

    context 'titles match' do
      it 'requests suitable tickets'
      it 'only checks un-united tickets'
      it 'fails if there are not exactly two matching titles'
      it 'unites the cards'
      it 'puts the redmine id in the description'
      it 'puts the trello id in the description'
      it 'marks for redmine and trello update'
    end
  end
end

