require 'active_record'

database_config = {
  :adapter => 'sqlite3',
  :database => 'db/test.sqlite3',
}

ActiveRecord::Base.establish_connection(database_config)
ActiveRecord::Base.logger = Logger.new('test.log')

