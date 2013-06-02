require 'model_spec_helper'

describe RoundTrip::Ticket do
  context 'scopes' do
    it 'needs specs'
  end

  context 'create_from_* methods' do
    before do
      RoundTrip::Ticket.stubs(:create!).with(anything)
    end

    describe '.create_from_redmine_resource' do
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

    describe '.create_from_trello_card' do
      let(:card_id) { 'aaaa' }
      let(:board_id) { 'bbbb' }
      let(:list_id) { 'cccc' }
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
          :list_id => list_id,
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
          :trello_list_id => list_id,
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

  describe '.check_repeated_redmine_ids' do
    let(:trello_has_redmine_id_relation) { stub('ActiveRecord::Relation', :group => group_by_redmine_id_relation) }
    let(:group_by_redmine_id_relation) { stub('ActiveRecord::Relation', :having => having_relation) }
    let(:having_relation) { stub('ActiveRecord::Relation', :count => count_relation) }
    let(:count_relation) { stub('ActiveRecord::Relation') }

    it 'needs specs' do
      pending
      trello_has_redmine_id_relation.stubs(:count).returns(2)
      #to raise_error(RuntimeError, /\d+ Trello cards found with the same Redmine ticket id: \d+, \d+/)
    end
  end

  describe '.merge_redmine' do
    let(:trello_id) { 'deadbeef' }
    let(:redmine_issue_id) { 12345 }
    let(:redmine_project_id) { 345 }
    let(:redmine_subject) { 'The redmine subject' }
    let(:redmine_description) { 'The redmine description' }
    let(:redmine_updated_on) { '20120304' }
    let(:trello_ticket_methods) do
      {
        :trello_id => trello_id,
        :trello_redmine_id => redmine_issue_id,
        :redmine_id= => nil,
        :redmine_project_id= => nil,
        :redmine_subject= => nil,
        :redmine_description= => nil,
        :redmine_updated_on= => nil,
        :redmine_trello_id= => nil,
        :save! => nil,
      }
    end
    let(:redmine_ticket_attributes) do
      {
        :redmine_id => redmine_issue_id,
        :redmine_project_id => redmine_project_id,
        :redmine_subject => redmine_subject,
        :redmine_description => redmine_description,
        :redmine_updated_on => redmine_updated_on,
        :destroy => nil,
      }
    end
    let(:trello_ticket) { stub('RoundTrip::Ticket (trello)', trello_ticket_methods) }
    let(:redmine_ticket) { stub('RoundTrip::Ticket (redmine)', redmine_ticket_attributes) }

    it 'copies the redmine data to the trello ticket' do
      pending

      expect(trello_ticket).to have_received(:redmine_id=).with(redmine_issue_id)
      expect(trello_ticket).to have_received(:redmine_project_id=).with(redmine_project_id)
      expect(trello_ticket).to have_received(:redmine_subject=).with(redmine_subject)
      expect(trello_ticket).to have_received(:redmine_description=).with(redmine_description)
      expect(trello_ticket).to have_received(:redmine_updated_on=).with(redmine_updated_on)
    end

    it 'copies the trello id to the redmine data' do
      pending

      expect(trello_ticket).to have_received(:redmine_trello_id=).with(trello_id)
    end

    it 'destroys the redmine ticket' do
      pending

      expect(redmine_ticket).to have_received(:destroy)
    end

    it 'saves the trello ticket' do
      pending

      expect(trello_ticket).to have_received(:save!)
    end
  end
end

