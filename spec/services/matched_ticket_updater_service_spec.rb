require 'model_spec_helper'

describe RoundTrip::MatchedTicketUpdaterService do
  describe '.initialize' do
    it 'expects a project'
  end

  describe '#run' do
    context 'where trello is more recent' do
      it 'finds united tickets' do
        RoundTrip::Ticket.stubs(:united).returns([])

        subject.run

        expect(RoundTrip::Ticket).to have_received(:united)
      end

      it 'copies trello data to redmine'
    end

    context 'where redmine is more recent' do
      it 'finds united tickets'
      it 'copies redmine data to trello'
    end
  end
end

