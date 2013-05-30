Before('@highline') do
  # stop the configurator clearing the screen
  RoundTrip::Configurator.any_instance.stub(:system).with('clear')

  @highline_input = StringIO.new
  @highline_stdout = StringIO.new
  RoundTrip::Configurator.high_line = HighLine.new(@highline_input, @highline_stdout)
end

After('@highline') do
end

