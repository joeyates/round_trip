require 'model_spec_helper'

module RoundTrip
  describe TrelloDownloaderService do
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
    let(:tickets_relation) { double('ActiveRecord::Relation', :destroy_all => nil) }
    let(:project) { double('Project', :config => project_config) }
    let(:authorizer) { double('Trello::Authorizer', :client => client) }
    let(:client) { double('Trello::Client') }
    let(:board) { double('Trello::Board', :name => 'My Board', :cards => [card]) }
    let(:card) { double('Trello::Card', card_attributes) }

    describe '#run' do
      subject { TrelloDownloaderService.new(project) }

      before do
        Ticket.stub(:where).with(:trello_board_id => trello_board_id).and_return(tickets_relation)
        Trello::Authorizer.stub(:new).with(*trello_authorization_config).and_return(authorizer)
        client.stub(:find).with(:boards, trello_board_id).and_return(board)
        Ticket.stub(:create_from_trello_card).with(project, card)
        subject.run
      end

      it 'checks for a trello board id' do
        expect(Ticket).to have_received(:where).with(:trello_board_id => trello_board_id)
      end

      it 'clears all previous tickets for the board' do
        expect(tickets_relation).to have_received(:destroy_all)
      end

      it 'creates an authorizer' do
        expect(Trello::Authorizer).to have_received(:new).with(*trello_authorization_config)
      end

      it 'requests the board' do
        expect(client).to have_received(:find).with(:boards, trello_board_id)
      end

      it 'creates tickets' do
        expect(Ticket).to have_received(:create_from_trello_card).with(project, card)
      end
    end
  end
end

