require 'active_record'
require 'active_record/migration'

project_root = File.expand_path('../../..', File.dirname(__FILE__))
database_pathname = File.join(project_root, 'db', 'test.sqlite3')
RoundTrip::DatabaseConnector.new(database_pathname).connect

class PendingMigrationError < Exception#:nodoc:
  def initialize
    command_line = 'rake db:migrate ROUND_TRIP_ENVIRONMENT=test'
    super("Migrations are pending; run '#{command_line}' to resolve this issue.")
  end
end

raise PendingMigrationError if ActiveRecord::Migrator.needs_migration?
