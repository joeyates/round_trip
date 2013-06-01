require 'active_record'

class RoundTrip::Ticket < ActiveRecord::Base
  self.table_name = 'round_trip_tickets'
end

