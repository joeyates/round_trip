FactoryGirl.define do
  factory :ticket, :class => RoundTrip::Ticket do
    factory :redmine_ticket do
      sequence(:redmine_id) { |id| id }
      sequence(:redmine_project_id) { |id| id }
      sequence(:redmine_subject) { |n| "Subject #{n}" }
      sequence(:redmine_description) { |n| "Description #{n}" }
      redmine_updated_on = DateTime.now
    end
  end
end

