require 'highline'

module RoundTrip; end

class RoundTrip::Configurator
  class << self
    attr_accessor :high_line
  end
  self.high_line = HighLine.new

  def run
    loop do
      system('clear')
      high_line.choose do |menu|
        menu.header = 'Choose a project'
        RoundTrip::Project.all.each do |project|
          menu.choice(project.name) do
            edit_project project
          end
        end
        menu.choice('add a project') do
          name = high_line.ask('name: ') do |q|
            q.default = ''
          end
          if name.match(/^([\w\s\d]+|)$/)
            RoundTrip::Project.create!(:name => name)
          end
        end
        menu.choice('quit (q)') do
          return
        end
      end
    end
  end

  private

  def high_line
    self.class.high_line
  end
end

