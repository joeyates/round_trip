Given 'I have started the configurator' do
  @configurator = RoundTrip::Configurator.new
end

#################
# project list

Given 'I already have some projects' do
  pending
end

Then 'I should see the list of projects' do
  pending
end

Then /^'([\w_]+') should be in the list$/ do
  pending
end

Given "I have chosen 'Add project'" do
  pending
end

#################
# project editor

When 'I exit the project' do
  pending
end

When /^I call the project '([\w_]+)'$/ do |project_name|
  pending
end

