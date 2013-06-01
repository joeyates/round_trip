class RoundTrip::TrelloDownloaderService
  def run
    RoundTrip::Ticket.destroy_all
  end
end

