Before('@highline') do
  # stop the configurator clearing the screen
  RoundTrip::Configurator::MenuBase.any_instance.stub(:system).with('clear')
end

