require 'highline/test_app'

class HighLine; end

module HighLine::RSpecHelper
  def create_test_app
    @app = HighLine::TestApp.new
  end

  def expect_page_to_exist(page_number)
    page_index = page_number.to_i
    pages = @app.pages.each.with_index.map { |p, i| "#{i}:\n#{p}" }.join("\n\n")
    page_error = "Page #{page_index} does not exist.\nPages are:\n#{pages}"
    expect(@app.pages.size).to be > page_index, page_error
  end
end

