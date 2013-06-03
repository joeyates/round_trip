FactoryGirl.define do
  factory :ticket, :class => RoundTrip::Ticket do
    factory :redmine_ticket do
      sequence(:redmine_id) { |id| id }
      sequence(:redmine_project_id) { |id| id }
      sequence(:redmine_subject) { |n| "Subject #{n}" }
      sequence(:redmine_description) { |n| "Description #{n}" }
      redmine_updated_on DateTime.now.strftime("%Y/%m/%d %H:%M:%S %Z")
    end

    factory :trello_ticket do
      sequence(:trello_id) { |id| id }
      sequence(:trello_board_id) { |id| id }
      sequence(:trello_list_id) { |id| id }
      sequence(:trello_name) { |n| "Name #{n}" }
      sequence(:trello_desc) { |n| "Description #{n}" }
      trello_last_activity_date DateTime.now.strftime("%Y/%m/%d %H:%M:%S %Z")
      sequence(:trello_url) { |n| "http://example.com/card/#{n}" }
      trello_closed false
    end
  end
end

