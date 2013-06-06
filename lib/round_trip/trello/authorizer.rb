require 'trello'

module RoundTrip
  module Trello; end

  class Trello::Authorizer
    attr_reader :key, :secret, :token
    attr_reader :client

    def initialize(key, secret, token)
      @key, @secret, @token = key, secret, token
    end

    def client
      @client ||= Trello::Client.new(
        :consumer_key => key,
        :consumer_secret => secret,
        :oauth_token => token,
        :oauth_token_secret => nil,
      )
    end
  end
end

