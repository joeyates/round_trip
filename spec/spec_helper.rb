require 'rspec'
require 'rspec/autorun'

require 'round_trip'

support_glob = File.expand_path(File.join('support', '**', '*.rb'), File.dirname(__FILE__))
Dir[support_glob].each { |f| require f }

