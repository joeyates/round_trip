require 'active_record'

module RoundTrip
  class RedmineAccount < Account
    CONFIGURATION = [
      :redmine_url, :redmine_key,
    ]

    def projects
      Redmine::Resource.setup(
        config[:redmine_url],
        config[:redmine_key]
      )
      Redmine::Project.all
    end
  end
end

