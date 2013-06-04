FactoryGirl.define do
  sequence(:redmine_project_id)
  sequence(:redmine_url) { |n| "http://example.com/issues/#{n}" }

  factory :project, :class => RoundTrip::Project do
    sequence(:name) { |n| "Project #{n}" }

    config do
      {
        :redmine_project_id => generate(:redmine_project_id),
        :redmine_url => generate(:redmine_url),
        :trello_board_id => generate(:trello_board_id),
      }
    end
  end
end

