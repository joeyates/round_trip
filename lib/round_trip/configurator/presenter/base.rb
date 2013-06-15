require 'active_support/core_ext' # delegate

module RoundTrip
  module Configurator::Presenter; end

  class Configurator::Presenter::Base
    attr_reader :target

    delegate :name, :name=, :config, :config=, :changed?, :save!, :to => :@target

    def initialize(target)
      @target = target
    end

    def to_s
      values = ["name: #{name}"] + each_configuration do |key, human_name|
        v = config[key]
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
      target.class::CONFIGURATION.map do |key|
        human_name = key.to_s.gsub('_', ' ')
        block.call(key, human_name)
      end
    end
  end
end

