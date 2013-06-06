require 'round_trip/trello/authorizer'

module RoundTrip
  module Trello; end

  class Trello::ConnectionTester
    attr_reader :project

    def initialize(project)
      @project = project
    end

    def run
      authorizer = Trello::Authorizer.new(
        project.config[:trello_key],
        project.config[:trello_secret],
        project.config[:trello_token],
      )
      authorizer.client.find(:members, 'me')
      [true, "It works"]
    rescue Exception => e
      [false, "Error: #{e.message}"]
    end
  end
end

