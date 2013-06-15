module RoundTrip
  FactoryGirl.define do
    sequence(:account_id)
    sequence(:redmine_url) { |n| "http://example.com/issues/#{n}" }
    sequence(:redmine_key) { |n| "#{n}redminekey" }
    sequence(:trello_key) { |n| "#{n}trellokey" }
    sequence(:trello_secret) { |n| "#{n}trellosecret" }
    sequence(:trello_token) { |n| "#{n}trellotoken" }

    factory :redmine_account, :class => RoundTrip::RedmineAccount do
      sequence(:name) { |n| "Redmine Account #{n}" }

      config do
        {
          :redmine_url => generate(:redmine_url),
          :redmine_key => generate(:redmine_key),
        }
      end
    end

    factory :trello_account, :class => RoundTrip::TrelloAccount do
      sequence(:name) { |n| "Trello Account #{n}" }

      config do
        {
          :trello_key => generate(:trello_key),
          :trello_secret => generate(:trello_secret),
          :trello_token => generate(:trello_token),
        }
      end
    end
  end
end

