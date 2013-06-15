require 'active_record'

module RoundTrip
  class RedmineAccount < Account
    CONFIGURATION = [
      :redmine_url, :redmine_key, :redmine_project_id,
    ]
  end
end


