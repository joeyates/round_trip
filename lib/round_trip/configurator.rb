require 'highline'

module RoundTrip; end

class RoundTrip::Configurator
  attr_reader :high_line

  def initialize(high_line)
    @high_line = high_line
  end

  def run
    MainMenu.new(high_line).run
  end

  class MenuBase
    attr_reader :high_line

    def initialize(high_line)
      @high_line = high_line
    end
  end

  class MainMenu < MenuBase
    def run
      loop do
        system('clear')
        high_line.choose do |menu|
          menu.header = 'Choose a project'
          RoundTrip::Project.all.each do |project|
            menu.choice(project.name) do
              ProjectEditor.new(high_line).run(project)
            end
          end
          menu.choice('add a project') do
            name = high_line.ask('name: ')
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
  end

  class ProjectEditor < MenuBase
    def run(project)
      loop do
        system('clear')
        high_line.choose do |menu|
          menu.header <<-EOT
Editing '#{project}'
          EOT
          menu.choice('quit (q)') do
            return
          end
        end
      end
    end
  end
end

