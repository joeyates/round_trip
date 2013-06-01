require 'model_spec_helper'

describe RoundTrip::TicketMatcherService do
  describe '.initialize' do
    it 'expects a redmine project id and a trello board id'
  end

  describe '#run' do
    context 'redmine id is in trello card, but not vice versa' do
      it 'only checks un-united tickets'
      it 'fails if the id is in more than one trello card'
      it 'unites the cards'
      it 'puts the trello id in the redmine issue'
      it "doesn't alter the redmine timestamp"
    end

    context 'trello id is in redmine issue, but not vice versa' do
      it 'only checks un-united tickets'
      it 'fails if the trello id is in more than one redmine issue'
      it 'unites the cards'
      it 'puts the redmine id in the trello card'
      it "doesn't alter the trello timestamp"
    end

    context 'titles match' do
      it 'only checks un-united tickets'
      it 'fails if there are not exactly two matching titles'
      it 'unites the cards'
      it 'puts the trello id in the redmine issue'
      it 'puts the redmine id in the trello card'
    end
  end
end

