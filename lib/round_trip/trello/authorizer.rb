require 'trello'

module RoundTrip
  module Trello; end

  class Trello::Authorizer
    attr_reader :key, :secret, :token
    attr_reader :client

    def self.for_account(trello_account)
      Trello::Authorizer.new(
        trello_account.config[:trello_key],
        trello_account.config[:trello_secret],
        trello_account.config[:trello_token],
      )
    end

    def initialize(key, secret, token)
      @key, @secret, @token = key, secret, token
    end

    def client
      @client ||= ::Trello::Client.new(
        :consumer_key => key,
        :consumer_secret => secret,
        :oauth_token => token,
        :oauth_token_secret => nil,
      )
    end
  end
end

