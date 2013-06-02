require 'round_trip/trello/authorizer'

module RoundTrip; end
module RoundTrip::Trello; end

class RoundTrip::Trello::ConnectionTester
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def run
    RoundTrip::Trello::Authorizer.new(config).run
    member = ::Trello::Member.find('me')
    $stderr.write "member: #{member.inspect}\n"
    [true, "It works"]
  rescue Exception => e
    [false, "Error: #{e.message}"]
  end
end

