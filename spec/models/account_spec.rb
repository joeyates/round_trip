require 'model_spec_helper'

module RoundTrip
  describe Account do
    it 'validates type' do
      should ensure_inclusion_of(:type).in_array(['RoundTrip::RedmineAccount', 'RoundTrip::TrelloAccount'])
    end
  end
end

