require 'round_trip/trello/authorizer'

module TrelloStubs
  include RSpec::Mocks::ArgumentMatchers

  def stub_trello
    stub_trello_user
  end

  def stub_trello_authorizer
    @trello_authorizer = stub('Authorizer')
    RoundTrip::Trello::Authorizer.stub(:new).with(anything, anything, anything).and_return(@trello_authorizer)
  end

  def stub_trello_board
    @board = stub('Board')
    @board.stub(:name).and_return('My board')
    @board.stub(:id).and_return('abc12345')
  end

  def stub_trello_user
    stub_trello_authorizer
    stub_trello_board
    @trello_user = stub('User')
    @trello_user.stub(:boards).and_return([@board])
    @trello_authorizer.stub_chain(:client, :find).and_return(@trello_user)
  end
end

