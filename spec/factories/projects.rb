FactoryGirl.define do
  factory :project, :class => RoundTrip::Project do
    sequence(:name) { |n| "Project #{n}" }
    config do
      {
        :redmine_project_id => 12345,
        :redmine_url => 'http://example.com',
        :trello_board_id => '123abc',
      }
    end
  end
end

