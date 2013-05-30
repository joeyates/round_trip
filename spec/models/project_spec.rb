require 'model_spec_helper'

describe RoundTrip::Project do
  it { should validate_presence_of(:name) }
end

