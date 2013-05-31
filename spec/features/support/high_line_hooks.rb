require 'highline/rspec_helper'
require 'round_trip/configurator/menu/base'

Before('@highline') do
  create_test_app

  # stop the configurator clearing the screen
  RoundTrip::Configurator::Menu::Base.any_instance.stub(:system).with('clear') do
    @app.handle_clear_screen
  end
end

