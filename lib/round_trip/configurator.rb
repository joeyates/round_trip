require 'highline'
require 'active_support'

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

  class ProjectMenuPresenter
    attr_reader :project

    delegate :name, :name=,
      :redmine, :redmine=,
      :trello, :trello=, :to => :@project

    def initialize(project)
      @project = project
    end

    def to_s
      [
        "name: #{name}",
        "trello key: #{trello[:key]}",
        "trello token: #{trello[:token]}",
      ].join("\n")
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
              ProjectEditor.new(high_line).run(ProjectMenuPresenter.new(project))
            end
          end
          menu.choice('add a project') do
            name = high_line.ask('name: ')
            if name.match(/^([\w\s\d]+|)$/)
              RoundTrip::Project.create!(:name => name)
            end
          end
          menu.choice('quit (q)') do
            system('clear')
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
          menu.header = project.to_s
          menu.choice('set trello key') do
            project.trello[:key] = high_line.ask('type the key: ')
          end
          menu.choice('set trello token') do
            project.trello[:token] = high_line.ask('type the token: ')
          end
          menu.choice('quit (q)') do
            system('clear')
            return
          end
        end
      end
    end
  end
end

