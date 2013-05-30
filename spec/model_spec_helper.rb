require 'spec_helper'
require 'round_trip/models'
require 'shoulda-matchers'

support_glob = File.expand_path(File.join('support', 'models', '**', '*.rb'), File.dirname(__FILE__))
Dir[support_glob].each { |f| require f }

