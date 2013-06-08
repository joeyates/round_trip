module RoundTrip
  class MatchedTicketUpdaterService
    def run
      Ticket.trello_newer.each do |t|
        t.redmine_subject = t.trello_name
        t.save!
      end
    end
  end
end

