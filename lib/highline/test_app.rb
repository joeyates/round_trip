require 'highline'

class HighLine; end

class HighLine::TestApp
  # the queue of input
  attr_reader :input
  # the current 'page' of output
  attr_reader :output
  attr_reader :pages

  def initialize
    @input = StringIO.new
    @output = StringIO.new
    @pages = []
  end

  def type(text)
    @input << "#{text}\n"
  end

  # When clear screen is issued, the current 'page' of HighLine output is
  # pushed onto the array :pages and output is re-initialized.
  def handle_clear_screen
    push_current_page
    @output.reopen(StringIO.new)
  end

  def run
    before_run
    high_line = HighLine.new(@input, @output)
    begin
      yield high_line
    rescue EOFError
      # we don't necessarily navigate all the way out of the program
      # swallow errors when input stream runs out
    ensure
      after_run
    end
  end

  def get_page(page_number)
    page_index = page_number.to_i
    @pages[page_index]
  end

  private

  def push_current_page
    @pages << @output.string
  end

  def before_run
    @input.rewind
  end

  def after_run
    push_current_page
    @output.close
  end
end
