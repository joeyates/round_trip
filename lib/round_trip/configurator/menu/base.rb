module RoundTrip
  class Configurator; end
  module Configurator::Menu; end

  class Configurator::Menu::Base
    attr_reader :high_line

    def initialize(high_line)
      @high_line = high_line
    end
  end
end

