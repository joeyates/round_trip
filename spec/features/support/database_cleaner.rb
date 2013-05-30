require 'database_cleaner'

AfterConfiguration do |config|
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with :truncation
end

Before do
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end

