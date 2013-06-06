require 'model_spec_helper'

module RoundTrip
  describe MatchedTicketUpdaterService do
    describe '.initialize' do
      it 'expects a project'
    end

    describe '#run' do
      context 'where trello is more recent' do
        it 'finds united tickets' do
          Ticket.stubs(:united).returns([])

          subject.run

          expect(Ticket).to have_received(:united)
        end

        it 'copies trello data to redmine'
      end

      context 'where redmine is more recent' do
        it 'finds united tickets'
        it 'copies redmine data to trello'
      end
    end
  end
end

