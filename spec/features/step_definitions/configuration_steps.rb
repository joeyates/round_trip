# @app is a HighLine::TestApp.
# Output is available at the end of the run.
# Configurator page numbering is 1-based - we get an initial clear screen at the main menu.
# Use
#   @app.dump_pages
# to debug.

include HighLine::RSpecHelper

Given /^I go to the projects menu$/ do
  @app.type 'manage projects'
end

Given /^I already have (\d+) projects?$/ do |count|
  @projects = create_list(:project, count.to_i)
end

Given /^I edit an existing project$/ do
  @project = create(:project)
  @app.type @project.name
end

Given /^I re-open the same project$/ do
  @app.type @project.name
end

When /^I type '([^']*)'$/ do |command|
  @app.type command
end

When /^I call the project '([^']+)'$/ do |project_name|
  @app.type project_name
end

When /^I set ([\w\s]+) to '([^']+)'$/ do |key, value|
  @app.type key.strip
  @app.type value.strip
end

# Always run this!
When 'I close the program' do
  @app.run do |high_line|
    @configurator = RoundTrip::Configurator.new(high_line)
    @configurator.run
  end
end

Then /^I should have seen the list of projects on page (\d+)$/ do |page_number|
  expect_page_to_exist(page_number)
  page = @app.get_page(page_number)
  RoundTrip::Project.all.each do |p|
    expect(page).to match(/\d+\. #{p.name}/)
  end
end

Then /^I should have seen '([^']+)' on page (\d+)$/ do |text, page_number|
  expect_page_to_exist(page_number)
  page = @app.get_page(page_number)
  expect(page).to include(text)
end

