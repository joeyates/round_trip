module RoundTrip; end
class RoundTrip::Configurator; end
module RoundTrip::Configurator::Menu; end

class RoundTrip::Configurator::Menu::Base
  attr_reader :high_line

  def initialize(high_line)
    @high_line = high_line
  end
end

