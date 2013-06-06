FactoryGirl.define do
  sequence(:trello_id)
  sequence(:trello_board_id)
  sequence(:trello_list_id)
  sequence(:trello_name)               { |n| "Name #{n}" }
  sequence(:trello_desc)               { |n| "Description #{n}" }
  sequence(:trello_last_activity_date) { |n| (DateTime.now - n).strftime("%Y/%m/%d %H:%M:%S %Z") }
  sequence(:trello_url)                { |n| "http://trello.com/card/#{n}" }

  factory :ticket, :class => RoundTrip::Ticket do
    trait :with_redmine_data do
      sequence(:redmine_id) { |id| id }
      sequence(:redmine_project_id) { |id| id }
      sequence(:redmine_subject) { |n| "Subject #{n}" }
      sequence(:redmine_description) { |n| "Description #{n}" }
      redmine_updated_on DateTime.now.strftime("%Y/%m/%d %H:%M:%S %Z")
    end

    trait :with_trello_data do
      trello_id                    { generate(:trello_id) }
      trello_board_id              { generate(:trello_board_id) }
      trello_list_id               { generate(:trello_list_id) }
      trello_name                  { generate(:trello_name) }
      trello_desc                  { generate(:trello_desc) }
      trello_last_activity_date    { generate(:trello_last_activity_date) }
      trello_url                   { generate(:trello_url) }
      trello_closed                false
    end

    trait :from_trello_card do
      ignore do
        id                       { generate(:trello_id) }
        board_id                 { generate(:trello_board_id) }
        list_id                  { generate(:trello_list_id) }
        name                     { generate(:trello_name) }
        description              { generate(:trello_desc) }
        last_activity_date       { generate(:trello_last_activity_date) }
        url                      { generate(:trello_url) }
        closed false
      end

      trello_id                    { id }
      trello_board_id              { board_id }
      trello_list_id               { list_id }
      trello_name                  { name }
      trello_desc                  { description }
      trello_last_activity_date    { last_activity_date }
      trello_url                   { url }
      trello_closed                false
    end

    factory :redmine_ticket, traits: [:with_redmine_data]
    factory :trello_ticket, traits: [:with_trello_data]
    factory :united_ticket, traits: [:with_redmine_data, :with_trello_data]
  end
end

