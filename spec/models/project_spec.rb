require 'model_spec_helper'

module RoundTrip
  describe Project do
    it { should validate_presence_of(:name) }
  end
end

