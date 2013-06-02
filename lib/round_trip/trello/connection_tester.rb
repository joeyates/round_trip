require 'round_trip/trello/authorizer'

module RoundTrip; end
module RoundTrip::Trello; end

class RoundTrip::Trello::ConnectionTester
  attr_reader :round_trip_project

  def initialize(round_trip_project)
    @round_trip_project = round_trip_project
  end

  def run
    authorizer = RoundTrip::Trello::Authorizer.new(
      round_trip_project.config[:trello_key],
      round_trip_project.config[:trello_secret],
      round_trip_project.config[:trello_token],
    )
    authorizer.client.find(:members, 'me')
    [true, "It works"]
  rescue Exception => e
    [false, "Error: #{e.message}"]
  end
end

