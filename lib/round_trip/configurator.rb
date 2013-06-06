require 'round_trip/configurator/menu/main'

module RoundTrip
  class Configurator
    attr_reader :high_line

    def initialize(high_line)
      @high_line = high_line
    end

    def run
      Configurator::Menu::Main.new(high_line).run
    end
  end
end

