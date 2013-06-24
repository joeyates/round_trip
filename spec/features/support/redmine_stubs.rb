require 'round_trip/redmine/resource'

Before('@redmine') do
  extend RSpec::Mocks::ArgumentMatchers

  RoundTrip::Redmine::Resource.
    stub(:setup).
    with(anything, anything)
  RoundTrip::Redmine::Project.stub(:find).with(anything).and_return('foo')
end

