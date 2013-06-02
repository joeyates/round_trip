require 'model_spec_helper'

describe RoundTrip::TrelloDownloaderService do
  let(:trello_key) { 'aaa' }
  let(:trello_secret) { 'bbb' }
  let(:trello_token) { 'ccc' }
  let(:trello_board_id) { '123abc' }
  let(:trello_authorization_config) { [trello_key, trello_secret, trello_token] }
  let(:project_config) do
    {
      :trello_key => trello_key,
      :trello_secret => trello_secret,
      :trello_token => trello_token,
      :trello_board_id => trello_board_id,
    }
  end
  let(:trello_card_id) { 'ddd' }
  let(:trello_card_name) { 'The card name' }
  let(:trello_card_description) { 'The card description' }
  let(:trello_last_activity_date) { DateTime.now }
  let(:trello_card_url) { 'https://example.com/card/url' }
  let(:card_attributes) do
    {
      :id => trello_card_id,
      :board_id => trello_board_id,
      :name => trello_card_name,
      :description => trello_card_description,
      :last_activity_date => trello_last_activity_date,
      :url => trello_card_url,
      :closed => false,
    }
  end
  let(:tickets_relation) { stub('ActiveRecord::Relation', :destroy_all => nil) }
  let(:round_trip_project) { stub('RoundTrip::Project', :config => project_config) }
  let(:authorizer) { stub('RoundTrip::Trello::Authorizer', :client => client) }
  let(:client) { stub('Trello::Client') }
  let(:board) { stub('Trello::Board', :name => 'My Board', :cards => [card]) }
  let(:card) { stub('Trello::Card', card_attributes) }

  describe '#run' do
    subject { RoundTrip::TrelloDownloaderService.new(round_trip_project) }

    before do
      RoundTrip::Ticket.stubs(:where).with(:trello_board_id => trello_board_id).returns(tickets_relation)
      RoundTrip::Trello::Authorizer.stubs(:new).with(*trello_authorization_config).returns(authorizer)
      client.stubs(:find).with(:boards, trello_board_id).returns(board)
      RoundTrip::Ticket.stubs(:create_from_trello_card).with(card)
      subject.run
    end

    it 'checks for a trello board id' do
      expect(RoundTrip::Ticket).to have_received(:where).with(:trello_board_id => trello_board_id)
    end

    it 'clears all previous tickets for the board' do
      expect(tickets_relation).to have_received(:destroy_all)
    end

    it 'creates an authorizer' do
      expect(RoundTrip::Trello::Authorizer).to have_received(:new).with(*trello_authorization_config)
    end

    it 'requests the board' do
      expect(client).to have_received(:find).with(:boards, trello_board_id)
    end

    it 'creates tickets' do
      expect(RoundTrip::Ticket).to have_received(:create_from_trello_card).with(card)
    end
  end
end

