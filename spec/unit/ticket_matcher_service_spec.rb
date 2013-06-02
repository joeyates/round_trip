require 'model_spec_helper'

describe RoundTrip::TicketMatcherService do
  describe '#run' do
    let(:attributes) do
      {
        :redmine_project_id => 'a',
        :redmine_url => 'b',
        :trello_board_id => 'c',
      }
    end
    let(:round_trip_project) { stub('RoundTrip::Project', :config => attributes) }

    subject { RoundTrip::TicketMatcherService.new(round_trip_project) }

    context 'config checks' do
      [:redmine_project_id, :redmine_url, :trello_board_id].each do |key|
        name = key.to_s.gsub('_', ' ')
        it "expects a #{name}" do
          partial = attributes.clone
          partial.delete(key)
          round_trip_project = stub('RoundTrip::Project', :config => partial)
          subject = RoundTrip::TicketMatcherService.new(round_trip_project)

          expect {
            subject.run
          }.to raise_error(RuntimeError, "#{name} not set")
        end
      end
    end

    context 'trello id is in redmine issue, but not vice versa' do
      it 'checks if the trello id is in more than one redmine issue'
      it 'requests suitable tickets'
      it 'extracts un-united tickets'
    end

    context 'trello card has redmine id' do
      let(:redmine_issue_id) { 12345 }
      let(:trello_ticket) { stub('RoundTrip::Ticket (trello)', :trello_redmine_id => redmine_issue_id, :merge_redmine => nil, :save! => nil) }
      let(:redmine_ticket) { stub('RoundTrip::Ticket (redmine)') }
      let(:trello_has_redmine_id_relation) { stub('ActiveRecord::Relation', :not_united => not_united_relation) }
      let(:not_united_relation) { stub('ActiveRecord::Relation', :all => [trello_ticket]) }

      subject { RoundTrip::TicketMatcherService.new(round_trip_project) }

      before do
        RoundTrip::Ticket.stubs(:trello_has_redmine_id).returns(trello_has_redmine_id_relation)
        RoundTrip::Ticket.stubs(:check_repeated_redmine_ids)
        RoundTrip::Ticket.stubs(:find).with(redmine_issue_id).returns(redmine_ticket)
      end

      it 'checks if the redmine id is in more than one trello card' do
        subject.run

        expect(RoundTrip::Ticket).to have_received(:check_repeated_redmine_ids)
      end

      it 'requests suitable tickets' do
        subject.run

        expect(RoundTrip::Ticket).to have_received(:trello_has_redmine_id)
      end

      it 'extracts un-united tickets' do
        subject.run

        expect(trello_has_redmine_id_relation).to have_received(:not_united)
      end

      it 'fails if the matching redmine issue is missing' do
        RoundTrip::Ticket.stubs(:find).with(redmine_issue_id).raises('not found')

        expect {
          subject.run
        }.to raise_error
      end

      it 'merges the redmine data into the trello ticket' do
        subject.run

        expect(trello_ticket).to have_received(:merge_redmine).with(redmine_ticket)
      end
    end

    context 'titles match' do
      it 'checks if there are cases of more than two matching titles'
      it 'requests suitable tickets'
      it 'extracts un-united tickets'
      it 'unites the cards'
    end
  end
end

