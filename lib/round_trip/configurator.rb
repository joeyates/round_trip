require 'round_trip/configurator/menu/main'

module RoundTrip; end

class RoundTrip::Configurator
  attr_reader :high_line

  def initialize(high_line)
    @high_line = high_line
  end

  def run
    RoundTrip::Configurator::Menu::Main.new(high_line).run
  end
end

