require 'active_support/core_ext' # delegate

module RoundTrip
  module Configurator::Presenter; end

  class Configurator::Presenter::Project
    attr_reader :project

    delegate :name, :name=, :config, :save!, :to => :@project

    def initialize(project)
      @project = project
    end

    def to_s
      values = ["name: #{name}"] + each_configuration do |key, human_name, v|
        value =
          if not v.nil? and v != ''
            v
          else
            '(unset)'
          end
        "#{human_name}: #{value}"
      end
      values.join("\n")
    end

    def each_configuration(&block)
      result = []
      Project::CONFIGURATION.map do |key|
        human_name = key.to_s.gsub('_', ' ')
        result << block.call(key, human_name, config[key])
      end
      result
    end
  end
end

