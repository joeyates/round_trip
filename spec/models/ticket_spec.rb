require 'model_spec_helper'

module RoundTrip
  describe Ticket do
    let(:project) { create(:project) }
    let(:redmine_ticket) { create(:redmine_ticket, project: project) }
    let(:trello_ticket) { create(:trello_ticket, project: project) }

    context 'create_from_* methods' do
      before do
        Ticket.stubs(:create!).with(anything)
      end

      describe '.redmine_subject_with_matching_trello_name' do
        it 'returns redmine tickets which have a matching trello ticket (by title)'
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
        let(:ticket_attributes) { attributes_for(:redmine_ticket).merge(project_id: project.id) }

        it 'creates tickets' do
          Ticket.create_from_redmine_resource(project, issue_resource)

          expect(Ticket).to have_received(:create!).with(ticket_attributes)
        end

        it 'extracts trello ids' do
          attributes_with_trello_id = ticket_attributes.merge(
            :redmine_description => issue_description_with_trello_id,
            :redmine_trello_id => trello_card_id
          )

          Ticket.create_from_redmine_resource(project, issue_resource_with_trello_id)

          expect(Ticket).to have_received(:create!).with(attributes_with_trello_id)
        end

        it 'removes ids from the description'
      end

      describe '.create_from_trello_card' do
        let(:card_attributes) { attributes_for(:trello_card) }
        let(:trello_card) { stub('Trello::Card', card_attributes) }
        let(:ticket_attributes) { attributes_for(:ticket, :from_trello_card, card_attributes).merge(project_id: project.id) }
        let(:redmine_issue_id) { 12345 }
        let(:card_description_with_redmine_id) { "## Redmine issue id: #{redmine_issue_id} ##\n#{card_attributes[:description]}" }
        let(:ticket_attributes_with_redmine_id) do
          ticket_attributes.merge(
            :trello_description => card_description_with_redmine_id,
            :trello_redmine_id => redmine_issue_id,
          )
        end

        it 'creates tickets' do
          Ticket.create_from_trello_card(project, trello_card)

          expect(Ticket).to have_received(:create!).with(ticket_attributes)
        end

        it 'extracts redmine ids' do
          trello_card = stub('Trello::Card', card_attributes.merge(:description => card_description_with_redmine_id))

          Ticket.create_from_trello_card(project, trello_card)

          expect(Ticket).to have_received(:create!).with(ticket_attributes_with_redmine_id)
        end

        it 'removes ids from the description'
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
        result = {87654 => 2}
        redmine_has_trello_id_relation.stubs(:for_trello_board => stub(:group => stub(:having => stub(:count => result))))

        expect {
          Ticket.check_repeated_trello_ids(123)
        }.to raise_error(RuntimeError, /\d+ Redmine issues found with the same Trello card id: \d+/)
      end
    end

    describe '.check_repeated_redmine_subjects' do
      let(:for_redmine_project_relation) { stub('ActiveRecord::Relation') }
      let(:redmine_subject_1) { 'Subject 1' }

      before do
        Ticket.stubs(:for_redmine_project).returns(for_redmine_project_relation)
      end

      it 'raises an error for repeated redmine issue subjects' do
        result = {redmine_subject_1 => 2}
        for_redmine_project_relation.stubs(:group => stub(:having => stub(:count => result)))

        expect {
          Ticket.check_repeated_redmine_subjects(123)
        }.to raise_error(RuntimeError, "2 Redmine issues found with the same subject: #{redmine_subject_1}")
      end
    end

    describe '.check_repeated_trello_names' do
      let(:for_trello_board_relation) { stub('ActiveRecord::Relation') }
      let(:trello_name_1) { 'Subject 1' }

      before do
        Ticket.stubs(:for_trello_board).returns(for_trello_board_relation)
      end

      it 'raises an error for repeated trello card names' do
        result = {trello_name_1 => 2}
        for_trello_board_relation.stubs(:group => stub(:having => stub(:count => result)))

        expect {
          Ticket.check_repeated_trello_names(123)
        }.to raise_error(RuntimeError, "2 Trello cards found with the same name: #{trello_name_1}")
      end
    end

    context 'associations' do
      it { should belong_to(:project) }
    end

    context 'validations' do
      it { should validate_presence_of(:project) }
    end

    describe '#merge_redmine' do
      before do
        redmine_ticket.stubs(:destroy)
        trello_ticket.stubs(:save!)
        trello_ticket.merge_redmine(redmine_ticket)
      end

      it 'fails if the tickets belong to different projects' do
        project_1 = create(:project)
        project_2 = create(:project)
        redmine_ticket = create(:redmine_ticket, project: project_1)
        trello_ticket = create(:trello_ticket, project: project_2)

        expect {
          trello_ticket.merge_redmine(redmine_ticket)
        }.to raise_error
      end

      it 'copies the redmine data to the trello ticket' do
        expect(trello_ticket.redmine_id).to eq(redmine_ticket.redmine_id)
        expect(trello_ticket.trello_redmine_id).to eq(redmine_ticket.redmine_id)
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

    describe '#merge_trello' do
      before do
        trello_ticket.stubs(:destroy)
        redmine_ticket.stubs(:save!)
      end

      it 'fails if the tickets belong to different projects' do
        project_1 = create(:project)
        project_2 = create(:project)
        redmine_ticket = create(:redmine_ticket, project: project_1)
        trello_ticket = create(:trello_ticket, project: project_2)

        expect {
          redmine_ticket.merge_trello(trello_ticket)
        }.to raise_error
      end

      it 'copies the trello data to the redmine ticket' do
        redmine_ticket.merge_trello(trello_ticket)

        expect(redmine_ticket.trello_id).to eq(trello_ticket.trello_id)
        expect(redmine_ticket.redmine_trello_id).to eq(redmine_ticket.trello_id)
        expect(redmine_ticket.trello_board_id).to eq(trello_ticket.trello_board_id)
        expect(redmine_ticket.trello_list_id).to eq(trello_ticket.trello_list_id)
        expect(redmine_ticket.trello_name).to eq(trello_ticket.trello_name)
        expect(redmine_ticket.trello_description).to eq(trello_ticket.trello_description)
        expect(redmine_ticket.trello_last_activity_date).to eq(trello_ticket.trello_last_activity_date)
        expect(redmine_ticket.trello_url).to eq(trello_ticket.trello_url)
        expect(redmine_ticket.trello_closed).to eq(trello_ticket.trello_closed)
      end

      it 'copies the redmine id to the trello data' do
        redmine_ticket.merge_trello(trello_ticket)

        expect(redmine_ticket.trello_redmine_id).to eq(redmine_ticket.redmine_id)
      end

      it 'destroys the trello ticket' do
        redmine_ticket.merge_trello(trello_ticket)

        expect(trello_ticket).to have_received(:destroy)
      end

      it 'saves the redmine ticket' do
        redmine_ticket.merge_trello(trello_ticket)

        expect(redmine_ticket).to have_received(:save!)
      end
    end
  end
end

