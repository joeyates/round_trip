Given /^I go to the accounts menu$/ do
  @client.type 'manage accounts'
end

Given /^I go to the projects menu$/ do
  @client.type 'manage projects'
end

Given /^I already have a Redmine account called '([^']+)'/ do |name|
  @redmine_account = create(:redmine_account, name: name)
end

Given /^I already have a Trello account called '([^']+)'/ do |name|
  @trello_account = create(:trello_account, name: name)
end

Given /^I edit an existing Redmine account$/ do
  @redmine_account = create(:redmine_account)
  @client.type 'manage accounts'
  @client.type @redmine_account.name
end

Given /^I edit an existing Trello account$/ do
  @trello_account = create(:trello_account)
  @client.type 'manage accounts'
  @client.type @trello_account.name
end

Given /^I already have (\d+) projects?$/ do |count|
  @projects = create_list(:project, count.to_i)
end

Given 'I have a project' do
  @project = create(:project, :unconfigured)
end

Given 'I have a project with accounts set' do
  step 'I have a project'
  @redmine_account = create(:redmine_account)
  @trello_account = create(:trello_account)
  @project.redmine_account = @redmine_account
  @project.trello_account = @trello_account
  @project.save!
end

Given 'I edit the project' do
  @client.type 'manage projects'
  @client.type @project.name
end

Given /^I edit an existing project$/ do
  step 'I have a project'
  step 'I edit the project'
end

Given /^I edit a project with accounts set$/ do
  step 'I have a project with accounts set'
  step 'I edit the project'
end

Given 'I edit a project with a Trello board set' do
  extend TrelloStubs
  stub_trello
  step 'I have a project with accounts set'
  @project.config = @project.config.merge(trello_board_id: @board.id)
  @project.save!
  step 'I edit the project'
end

Given /^I edit Trello list matchers$/ do
  step 'I edit a project with a Trello board set'
  @client.type 'trello list matchers'
end

Given /^I re-open the same project$/ do
  @client.type @project.name
end

When /^I type '([^']*)'$/ do |command|
  @client.type command
end

When /^I call the project '([^']+)'$/ do |project_name|
  @client.type project_name
end

When /^I set ([\w\s]+) to '([^']+)'$/ do |key, value|
  @client.type key.strip
  @client.type value.strip
end

When /^I wait for ([^\s]+) seconds?$/ do |seconds|
  sleep seconds.to_f
end

Then /^I should see the list of projects/ do
  RoundTrip::Project.all.each do |p|
    expect(@client.output).to match(/\d+\. #{p.name}/)
  end
end

Then /^I should see '([^']+)'$/ do |text|
  expect(@client.output).to include(text)
end

Then /^I should see text matching '([^']+)'$/ do |regexp|
  expect(@client.output).to match(Regexp.new(regexp))
end

