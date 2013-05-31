module HighLineHelpers
  def create_streams
    @high_line_input = StringIO.new
    @high_line_output = StringIO.new
    @high_line_pages = []
  end

  def create_configurator
    create_streams
    high_line = HighLine.new(@high_line_input, @high_line_output)
    @configurator = RoundTrip::Configurator.new(high_line)
  end

  def add_input_line(text)
    @high_line_input << "#{text}\n"
  end

  def push_current_page
    @high_line_pages << @high_line_output.string
  end

  def handle_clear_screen
    push_current_page
    @high_line_output.reopen(StringIO.new)
  end
  
  def before_configurator_run
    append_quit
    @high_line_input.rewind
  end

  def after_configurator_run
    push_current_page
    @high_line_output.close
  end

  def run_configurator
    before_configurator_run
    begin
      @configurator.run
    rescue EOFError
    ensure
      after_configurator_run
    end
  end

  def append_quit
    @high_line_input.seek(@high_line_input.length)
    @high_line_input << "quit\n"
  end

  def expect_page_to_exist(page_number)
    page_index = page_number.to_i
    pages = @high_line_pages.each.with_index.map { |p, i| "#{i}:\n#{p}" }.join("\n\n")
    page_error = "Page #{page_index} does not exists.\nPages are:\n#{pages}"
    expect(@high_line_pages.size).to be > page_index, page_error
  end

  def get_page(page_number)
    page_index = page_number.to_i
    page = @high_line_pages[page_index]
  end
end

Before('@highline') do
  # stop the configurator clearing the screen
  RoundTrip::Configurator::MenuBase.any_instance.stub(:system).with('clear') do
    handle_clear_screen
  end
end

