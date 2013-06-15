require 'model_spec_helper'

describe RoundTrip::Project do
  subject { create(:project) }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }

    context 'redmine_account' do
      it 'fails for non-redmine accounts' do
        subject.redmine_account = create(:trello_account)
        expect {
          subject.save!
        }.to raise_error(ActiveRecord::RecordInvalid, /must be a RoundTrip::RedmineAccount/)
      end
    end

    context 'trello_account' do
      it 'fails for non-trello accounts' do
        subject.trello_account = create(:redmine_account)
        expect {
          subject.save!
        }.to raise_error(ActiveRecord::RecordInvalid, /must be a RoundTrip::TrelloAccount/)
      end
    end
  end
end

