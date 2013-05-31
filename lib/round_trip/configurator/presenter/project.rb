require 'active_support/core_ext' # delegate

module RoundTrip::Configurator::Presenter; end

class RoundTrip::Configurator::Presenter::Project
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
    RoundTrip::Project::CONFIGURATION.map do |attribute_name, keys|
      attribute = project.send(attribute_name)
      keys.map do |key|
        result << block.call(attribute_name, attribute, key, attribute[key])
      end
    end
    result
  end
end

