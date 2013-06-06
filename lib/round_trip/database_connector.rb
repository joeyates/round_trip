require 'active_record'

module RoundTrip
  class DatabaseConnector
    attr_reader :database_pathname

    def initialize(database_pathname)
      @database_pathname = database_pathname
    end

    def connect
      raise Errno::EACCES.new(database_path) unless File.writable?(database_path)
      if File.exist?(database_pathname)
        raise Errno::EACCES.new(database_pathname) unless File.writable?(database_pathname)
      end
      ActiveRecord::Base.establish_connection(database_config)
    end

    private

    def database_path
      File.dirname(database_pathname)
    end

    def database_config
      {
        :adapter => 'sqlite3',
        :database => database_pathname,
      }
    end
  end
end

