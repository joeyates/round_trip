require 'highline/test'
require 'round_trip/configurator/menu/base'

Before('@highline') do
  @client = HighLine::Test::Client.new
  @client.run do |driver|
    # stop the configurator clearing the screen
    RoundTrip::Configurator::Menu::Base.any_instance.stub(:system).with('clear') do
      driver.inject("\n---- Page separator ---\n")
    end

    extend RedmineStubs
    extend TrelloStubs
    stub_redmine
    stub_trello

    configurator = RoundTrip::Configurator.new(driver.high_line)
    configurator.run
  end
end

After('@highline') do
  @client.cleanup
end

