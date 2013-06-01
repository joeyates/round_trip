class RoundTrip::RedmineDownloaderService
  attr_reader :redmine_project_id

  def initialize(redmine_project_id)
    @redmine_project_id = redmine_project_id
  end

  def run
  end
end

