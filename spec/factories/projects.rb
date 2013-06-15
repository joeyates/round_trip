FactoryGirl.define do
  sequence(:redmine_project_id)
  sequence(:trello_board_id) { |n| "#{n}aaaaaaaaaaa" }

  factory :project, :class => RoundTrip::Project do
    sequence(:name) { |n| "Project #{n}" }

    config do
      {
        :redmine_project_id => generate(:redmine_project_id),
        :trello_board_id => generate(:trello_board_id),
      }
    end

    trait(:unconfigured) do
      config { {} }
    end
  end
end

