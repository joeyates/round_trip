def append_quit
  @highline_input.seek(@highline_input.length)
  @highline_input << "quit\n"
end

Given 'I have started the configurator' do
  @configurator = RoundTrip::Configurator.new
end

Given /I already have (\d+) projects?$/ do |count|
  @projects = create_list(:project, count.to_i)
end

Given "I have chosen 'add a project'" do
  @highline_input << "add a project\n"
end

Given /^I have chosen to edit a project$/ do
  @project = create(:project)
  @highline_input << "#{@project.name}\n"
end

When /I type enter/ do
  @highline_input << "\n"
end

When /I type '([\w\s]+)'/ do |command|
  @highline_input << "#{command}\n"
end

When /^I call the project '([\w\d\s]+)'$/ do |project_name|
  @highline_input << "#{project_name}\n"
end

Then 'I should see the list of projects' do
  append_quit
  @highline_input.rewind
  @configurator.run
  output = @highline_stdout.string
  RoundTrip::Project.all.each do |p|
    expect(output).to match(/\d+\. #{p.name}/)
  end
end

Then /^'([\w_]+)' should be in the list$/ do |name|
  append_quit
  @highline_input.rewind
  @configurator.run
  output = @highline_stdout.string
  expect(output).to match(/\d+\. #{name}/)
end

