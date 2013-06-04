# N.B. as Trello::Card saves to the Trello site, avoid running :save

FactoryGirl.define do
  factory :trello_card, :class => Trello::Card do
    id                  { generate(:trello_id) }
    board_id            { generate(:trello_board_id) }
    list_id             { generate(:trello_list_id) }
    name                { generate(:trello_name) }
    description         { generate(:trello_desc) }
    last_activity_date  { generate(:trello_last_activity_date) }
    url                 { generate(:trello_url) }
    closed              false
    before(:create) do
      raise "Don't try to save Trello::Cards"
    end
  end
end

