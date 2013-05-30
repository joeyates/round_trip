FactoryGirl.define do
  factory :project, :class => RoundTrip::Project do
    sequence(:name) { |n| "Project #{n}" }
  end
end

