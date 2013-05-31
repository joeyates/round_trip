require 'highline'
require 'active_support'
require 'active_support/core_ext'

module RoundTrip; end

class RoundTrip::Configurator
  CONFIGURATION = [
    [:trello,  [:key, :token, :board_id]],
    [:redmine, [:url, :key, :project_id]],
  ]
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
      :trello, :trello=,
      :save!,
      :to => :@project

    def initialize(project)
      @project = project
    end

    def to_s
      values = ["name: #{name}"] + each_configuration do |name, _, key, v|
        value =
          if not v.nil? and v != ''
            v
          else
            '(unset)'
          end
        "#{name} #{key}: #{value}"
      end
      values.join("\n")
    end

    def each_configuration(&block)
      result = []
      CONFIGURATION.map do |attribute_name, keys|
        attribute = project.send(attribute_name)
        keys.map do |key|
          result << block.call(attribute_name, attribute, key, attribute[key])
        end
      end
      result
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
          menu.header = project.to_s + "\n\nEdit a setting"
          project.each_configuration do |name, attribute, key, value|
            full_key_name = "#{name} #{key}"
            menu.choice(full_key_name) do
              attribute[key] = high_line.ask("#{full_key_name}: ")
            end
          end
          menu.choice('save') do
            project.save!
            system('clear')
            return
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

