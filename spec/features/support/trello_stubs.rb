require 'round_trip/trello/authorizer'

module TrelloStubs
  include RSpec::Mocks::ArgumentMatchers

  def stub_trello
    stub_trello_user
  end

  def stub_trello_authorizer
    @trello_authorizer = stub('Authorizer')
    RoundTrip::Trello::Authorizer.stub(:new).with(anything, anything, anything).and_return(@trello_authorizer)
    @trello_client = stub('Client')
    @trello_authorizer.stub(:client).and_return(@trello_client)
  end

  def stub_trello_board
    @board = stub('Board')
    @board.stub(:name).and_return('My board')
    @board.stub(:id).and_return('abc12345')
    names = ['Ideas', 'Backlog 123', 'Sprint 95', 'My feature', 'Done', 'Archived']
    lists = names.map do |name|
      list = stub('List')
      list.stub(:name).and_return(name)
      list.stub(:closed).and_return(false)
      list
    end
    @board.stub(:lists).and_return(lists)
    @trello_client.stub(:find).with(:boards, anything).and_return(@board)
  end

  def stub_trello_user
    stub_trello_authorizer
    stub_trello_board
    @trello_user = stub('User')
    @trello_client.stub(:find).with(:members, 'me').and_return(@trello_user)
    @trello_user.stub(:boards).with().and_return([@board])
  end
end

