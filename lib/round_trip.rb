module RoundTrip
  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new('/dev/null')
  end
end

require 'round_trip/database_connector'
require 'round_trip/configurator'
require 'round_trip/synchroniser'

