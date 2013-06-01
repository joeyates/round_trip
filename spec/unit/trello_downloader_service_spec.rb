require 'model_spec_helper'

describe RoundTrip::TrelloDownloaderService do
  describe '#run' do
    before do
      RoundTrip::Ticket.stubs(:destroy_all)
    end

    it 'clears all previous tickets for the board' do
      subject.run

      expect(RoundTrip::Ticket).to have_received(:destroy_all)
    end
  end
end

