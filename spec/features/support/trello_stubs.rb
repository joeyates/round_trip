require 'round_trip/trello/authorizer'

module TrelloStubs
  extend RSpec::Mocks::ArgumentMatchers

  @trello_authorizer = stub('Authorizer')
  @trello_user = stub('User')
  @board = stub('Board')
  @trello_authorizer.stub_chain(:client, :find).and_return(@trello_user)
  @trello_user.stub(:boards).and_return([@board])
  @board.stub(:name).and_return('My board')
  @board.stub(:id).and_return('abc12345')
  RoundTrip::Trello::Authorizer.stub(:new).with(anything, anything, anything).and_return(@trello_authorizer)
end

