require 'trello'

module RoundTrip; end
module RoundTrip::Trello; end

class RoundTrip::Trello::ConnectionTester
  attr_reader :config

  def initialize(config)
    @config = config
  end

  def run
    # The following is adapted from ruby-trello (https://github.com/jeremytregunna/ruby-trello)
    ::Trello::Authorization.instance_eval do
      if const_defined?(:AuthPolicy)
        remove_const :AuthPolicy
      end
      verbose, $VERBOSE = $VERBOSE, nil
      const_set :AuthPolicy, ::Trello::Authorization::OAuthPolicy
      $VERBOSE = verbose
    end
    # This line is a hack to allow multiple different Trello auths to be used
    # during a single run; the Trello module will cache the consumer otherwise.
    ::Trello::Authorization::OAuthPolicy.instance_variable_set(:@consumer, nil)

    ::Trello::Authorization::OAuthPolicy.consumer_credential = ::Trello::Authorization::OAuthCredential.new(config[:key], config[:secret])
    ::Trello::Authorization::OAuthPolicy.token = ::Trello::Authorization::OAuthCredential.new(config[:token])

    member = ::Trello::Member.find('me')
    $stderr.write "member: #{member.inspect}\n"
    [true, "It works"]
  rescue Exception => e
    [false, "Error: #{e.message}"]
  end
end

