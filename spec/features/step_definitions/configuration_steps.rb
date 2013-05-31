# Note: when clear screen is issued, the current 'page' of HighLine output is
# pushed onto the array @high_line_pages (see support/high_line_hooks.rb.
# The current 'page' is the contents of @high_line_output

include HighLineHelpers

Given 'I have started the configurator' do
  create_configurator
end

Given /^I already have (\d+) projects?$/ do |count|
  @projects = create_list(:project, count.to_i)
end

Given /^I have chosen to edit a project$/ do
  @project = create(:project)
  add_input_line @project.name
end

When /^I type enter$/ do
  add_input_line ''
end

When /^I type '([\w\s]+)'$/ do |command|
  add_input_line command
end

When /^I call the project '([\w\d\s]+)'$/ do |project_name|
  add_input_line project_name
end

# Always run this!
When 'I close the program' do
  run_configurator
end

# page_number is 1--based - we get an initial clear screen at the beginning of
# the Configurator

Then /^I should have seen the list of projects on page (\d+)$/ do |page_number|
  expect_page_to_exist(page_number)
  page = get_page(page_number)
  RoundTrip::Project.all.each do |p|
    expect(page).to match(/\d+\. #{p.name}/)
  end
end

Then /^I should have seen '([^']+)' on page (\d+)$/ do |text, page_number|
  expect_page_to_exist(page_number)
  page = get_page(page_number)
  expect(page).to include(text)
end

