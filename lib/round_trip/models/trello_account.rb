module RoundTrip
  class TrelloAccount < Account
    CONFIGURATION = [
      :trello_key, :trello_secret, :trello_token,
    ]

    def boards
      authorizer = Trello::Authorizer.new(
        config[:trello_key],
        config[:trello_secret],
        config[:trello_token],
      )
      user = authorizer.client.find(:members, 'me')
      user.boards
    end
  end
end

