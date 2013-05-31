def append_quit
  @high_line_input.seek(@high_line_input.length)
  @high_line_input << "quit\n"
end

Given 'I have started the configurator' do
  @high_line_input = StringIO.new
  @high_line_stdout = StringIO.new
  high_line = HighLine.new(@high_line_input, @high_line_stdout)
  @configurator = RoundTrip::Configurator.new(high_line)
end

Given /I already have (\d+) projects?$/ do |count|
  @projects = create_list(:project, count.to_i)
end

Given "I have chosen 'add a project'" do
  @high_line_input << "add a project\n"
end

Given /^I have chosen to edit a project$/ do
  @project = create(:project)
  @high_line_input << "#{@project.name}\n"
end

When /I type enter/ do
  @high_line_input << "\n"
end

When /I type '([\w\s]+)'/ do |command|
  @high_line_input << "#{command}\n"
end

When /^I call the project '([\w\d\s]+)'$/ do |project_name|
  @high_line_input << "#{project_name}\n"
end

Then 'I should see the list of projects' do
  append_quit
  @high_line_input.rewind
  @configurator.run
  output = @high_line_stdout.string
  RoundTrip::Project.all.each do |p|
    expect(output).to match(/\d+\. #{p.name}/)
  end
end

Then /^'([\w_]+)' should be in the list$/ do |name|
  append_quit
  @high_line_input.rewind
  @configurator.run
  output = @high_line_stdout.string
  expect(output).to match(/\d+\. #{name}/)
end

Then /I should see '([^']+)'$/ do |text|
  append_quit
  @high_line_input.rewind
  @configurator.run
  output = @high_line_stdout.string
  expect(output).to match(/#{text}/)
end

