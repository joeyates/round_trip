require 'round_trip/trello/authorizer'

module RoundTrip; end
module RoundTrip::Trello; end

class RoundTrip::Trello::ConnectionTester
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def run
    authorizer = RoundTrip::Trello::Authorizer.new(config)
    authorizer.client.find(:members, 'me')
    [true, "It works"]
  rescue Exception => e
    [false, "Error: #{e.message}"]
  end
end

