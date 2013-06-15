module RoundTrip
  class TrelloAccount < Account
    CONFIGURATION = [
      :trello_key, :trello_secret, :trello_token,
    ]
  end
end

