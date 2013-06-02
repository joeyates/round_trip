require 'model_spec_helper'

describe RoundTrip::Ticket do
  before do
    RoundTrip::Ticket.stubs(:create!).with(anything)
  end

  describe '#create_from_redmine_resource' do
    let(:redmine_project_id) { 12345 }
    let(:trello_card_id) { 'abcdef' }
    let(:issue_description) { "The description\n" }
    let(:issue_description_with_trello_id) { "## Trello card id: #{trello_card_id} ##\nThe description\n" }
    let(:resource_attribs) do
      {
        :id => 123,
        :project => stub('RoundTrip::Redmine::Issue', :id => redmine_project_id),
        :updated_on => '2013/05/17 18:15:28 +0200',
        :subject => 'The Subject',
        :description => issue_description,
      }
    end
    let(:resource_attribs_with_trello_id) { resource_attribs.merge(:description => issue_description_with_trello_id) }
    let(:issue_resource) { stub('RoundTrip::Redmine::Issue', resource_attribs) }
    let(:issue_resource_with_trello_id) { stub('RoundTrip::Redmine::Issue', resource_attribs_with_trello_id) }
    let(:ticket_attributes) do
      {
        :redmine_id => 123,
        :redmine_project_id => redmine_project_id,
        :redmine_updated_on => '2013/05/17 18:15:28 +0200',
        :redmine_subject => 'The Subject',
        :redmine_description => issue_description,
      }
    end

    it 'creates tickets' do
      RoundTrip::Ticket.create_from_redmine_resource(issue_resource)

      expect(RoundTrip::Ticket).to have_received(:create!).with(ticket_attributes)
    end

    it 'extracts trello ids' do
      attributes_with_trello_id = ticket_attributes.merge(
        :redmine_description => issue_description_with_trello_id,
        :redmine_trello_id => trello_card_id
      )

      RoundTrip::Ticket.create_from_redmine_resource(issue_resource_with_trello_id)

      expect(RoundTrip::Ticket).to have_received(:create!).with(attributes_with_trello_id)
    end
  end

  describe '#create_from_trello_card' do
    let(:card_id) { 'aaaa' }
    let(:board_id) { 'bbbb' }
    let(:redmine_issue_id) { 12345 }
    let(:card_name) { 'Card name' }
    let(:card_description) { "Card description\n" }
    let(:card_description_with_redmine_id) { "## Redmine issue id: #{redmine_issue_id} ##\n#{card_description}" }
    let(:card_last_activity_date) { '2013-06-02T18:30:05+02:00' }
    let(:card_url) { 'http://example.com/card/1' }
    let(:card_attributes) do
      {
        :id => card_id,
        :board_id => board_id,
        :name => card_name,
        :description => card_description,
        :last_activity_date => card_last_activity_date,
        :url => card_url,
        :closed => false,
      }
    end
    let(:trello_card) { stub('Trello::Card', card_attributes) }
    let(:ticket_attributes) do
      {
        :trello_id => card_id,
        :trello_board_id => board_id,
        :trello_name => card_name,
        :trello_desc => card_description,
        :trello_last_activity_date => card_last_activity_date,
        :trello_url => card_url,
        :trello_closed => false,
      }
    end
    let(:ticket_attributes_with_redmine_id) do
      ticket_attributes.merge(
        :trello_desc => card_description_with_redmine_id,
        :trello_redmine_id => redmine_issue_id,
      )
    end

    it 'creates tickets' do
      RoundTrip::Ticket.create_from_trello_card(trello_card)

      expect(RoundTrip::Ticket).to have_received(:create!).with(ticket_attributes)
    end

    it 'extracts redmine ids' do
      trello_card = stub('Trello::Card', card_attributes.merge(:description => card_description_with_redmine_id))

      RoundTrip::Ticket.create_from_trello_card(trello_card)

      expect(RoundTrip::Ticket).to have_received(:create!).with(ticket_attributes_with_redmine_id)
    end
  end
end

