require 'model_spec_helper'

module RoundTrip
  describe Ticket do
    context 'create_from_* methods' do
      before do
        Ticket.stubs(:create!).with(anything)
      end

      describe '.create_from_redmine_resource' do
        let(:trello_card_id) { 'abcdef' }
        let(:issue_description_with_trello_id) { "## Trello card id: #{trello_card_id} ##\nThe description\n" }
        let(:resource_attribs) do
          {
            :id => ticket_attributes[:redmine_id],
            :project => stub('Redmine::Issue', :id => ticket_attributes[:redmine_project_id]),
            :updated_on => ticket_attributes[:redmine_updated_on],
            :subject => ticket_attributes[:redmine_subject],
            :description => ticket_attributes[:redmine_description],
          }
        end
        let(:resource_attribs_with_trello_id) { resource_attribs.merge(:description => issue_description_with_trello_id) }
        let(:issue_resource) { stub('Redmine::Issue', resource_attribs) }
        let(:issue_resource_with_trello_id) { stub('Redmine::Issue', resource_attribs_with_trello_id) }
        let(:ticket_attributes) { attributes_for(:redmine_ticket) }

        it 'creates tickets' do
          Ticket.create_from_redmine_resource(issue_resource)

          expect(Ticket).to have_received(:create!).with(ticket_attributes)
        end

        it 'extracts trello ids' do
          attributes_with_trello_id = ticket_attributes.merge(
            :redmine_description => issue_description_with_trello_id,
            :redmine_trello_id => trello_card_id
          )

          Ticket.create_from_redmine_resource(issue_resource_with_trello_id)

          expect(Ticket).to have_received(:create!).with(attributes_with_trello_id)
        end
      end

      describe '.create_from_trello_card' do
        let(:card_attributes) { attributes_for(:trello_card) }
        let(:trello_card) { stub('Trello::Card', card_attributes) }
        let(:ticket_attributes) { attributes_for(:ticket, :from_trello_card, card_attributes) }
        let(:redmine_issue_id) { 12345 }
        let(:card_description_with_redmine_id) { "## Redmine issue id: #{redmine_issue_id} ##\n#{card_attributes[:description]}" }
        let(:ticket_attributes_with_redmine_id) do
          ticket_attributes.merge(
            :trello_desc => card_description_with_redmine_id,
            :trello_redmine_id => redmine_issue_id,
          )
        end

        it 'creates tickets' do
          Ticket.create_from_trello_card(trello_card)

          expect(Ticket).to have_received(:create!).with(ticket_attributes)
        end

        it 'extracts redmine ids' do
          trello_card = stub('Trello::Card', card_attributes.merge(:description => card_description_with_redmine_id))

          Ticket.create_from_trello_card(trello_card)

          expect(Ticket).to have_received(:create!).with(ticket_attributes_with_redmine_id)
        end
      end
    end

    describe '.check_repeated_redmine_ids' do
      let(:trello_has_redmine_id_relation) { stub('ActiveRecord::Relation') }

      before do
        Ticket.stubs(:trello_has_redmine_id).returns(trello_has_redmine_id_relation)
      end

      it 'raises an error for duplicate redmine ids' do
        result = {'123454f947c12c3479004705' => 2, '123454f947c12c3479004706' => 3}
        trello_has_redmine_id_relation.stubs(:for_redmine_project => stub(:group => stub(:having => stub(:count => result))))

        expect {
          Ticket.check_repeated_redmine_ids(123)
        }.to raise_error(RuntimeError, /\d+ Trello cards found with the same Redmine issue id: \d+/)
      end
    end

    describe '.check_repeated_trello_ids' do
      let(:redmine_has_trello_id_relation) { stub('ActiveRecord::Relation') }

      before do
        Ticket.stubs(:redmine_has_trello_id).returns(redmine_has_trello_id_relation)
      end

      it 'raises an error for duplicate trello ids' do
        result = {87654 => 2, 12345 => 3}
        redmine_has_trello_id_relation.stubs(:for_trello_board => stub(:group => stub(:having => stub(:count => result))))

        expect {
          Ticket.check_repeated_trello_ids(123)
        }.to raise_error(RuntimeError, /\d+ Redmine issues found with the same Trello card id: \d+/)
      end
    end

    describe '.copy_redmine_fields' do
      it "doesn't modify the ticket to be copied from"
      it 'copies the redmine fields'
      it 'leaves other fields unchanged'
    end

    context 'associations' do
      it { should belong_to(:project) }
    end

    context 'validations' do
      it { should validate_presence_of(:project) }
    end

    describe '#merge_redmine' do
      let(:trello_ticket) { create(:ticket) }
      let(:redmine_ticket) { create(:redmine_ticket) }

      before do
        redmine_ticket.stubs(:destroy)
        trello_ticket.stubs(:save!)
        trello_ticket.merge_redmine(redmine_ticket)
      end

      it 'copies the redmine data to the trello ticket' do
        expect(trello_ticket.redmine_id).to eq(redmine_ticket.redmine_id)
        expect(trello_ticket.redmine_project_id).to eq(redmine_ticket.redmine_project_id)
        expect(trello_ticket.redmine_subject).to eq(redmine_ticket.redmine_subject)
        expect(trello_ticket.redmine_description).to eq(redmine_ticket.redmine_description)
        expect(trello_ticket.redmine_updated_on).to eq(redmine_ticket.redmine_updated_on)
      end

      it 'copies the trello id to the redmine data' do
        expect(trello_ticket.redmine_trello_id).to eq(trello_ticket.trello_id)
      end

      it 'destroys the redmine ticket' do
        expect(redmine_ticket).to have_received(:destroy)
      end

      it 'saves the trello ticket' do
        expect(trello_ticket).to have_received(:save!)
      end
    end
  end
end

