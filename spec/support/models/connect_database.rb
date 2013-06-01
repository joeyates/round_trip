require 'active_record'

ENVIRONMENT=ENV['ROUND_TRIP_ENVIRONMENT'] || 'test'

database_config = {
  :adapter => 'sqlite3',
  :database => "db/#{ENVIRONMENT}.sqlite3",
}

ActiveRecord::Base.establish_connection(database_config)

