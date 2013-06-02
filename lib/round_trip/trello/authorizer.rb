require 'trello'

module RoundTrip; module Trello; end; end

class RoundTrip::Trello::Authorizer
  attr_reader :config
  attr_reader :client

  def initialize(config)
    @config = config
  end

  def client
    @client ||= Trello::Client.new(
      :consumer_key => config[:key],
      :consumer_secret => config[:secret],
      :oauth_token => config[:token],
      :oauth_token_secret => nil,
    )
  end
end

