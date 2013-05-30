module RoundTrip; end

class RoundTrip::Configurator
  attr_reader :database_pathname

  def initialize(database_pathname)
    @database_pathname =  database_pathname
  end

  def run
    raise Errno::EACCES.new(database_path) unless File.writable?(database_path)
    if File.exist?(database_pathname)
      raise Errno::EACCES.new(database_pathname) unless File.writable?(database_pathname)
    end
  end

  private

  def database_path
    File.dirname(database_pathname)
  end
end

