require 'round_trip/trello/authorizer'

Before('@trello') do
  extend RSpec::Mocks::ArgumentMatchers

  @trello_authorizer = stub('Authorizer')
  @trello_authorizer.stub_chain(:client, :find).and_return('ok')
  RoundTrip::Trello::Authorizer.stub(:new).with(anything, anything, anything).and_return(@trello_authorizer)
end

