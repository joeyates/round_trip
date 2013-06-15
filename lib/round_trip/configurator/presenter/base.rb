module RoundTrip
  module Configurator::Presenter; end

  class Configurator::Presenter::Base
    attr_reader :target

    def initialize(target)
      @target = target
    end

    def method_missing(method, *args)
      target.send(method, *args)
    end

    def to_s
      display_pairs.each do |human_name, v|
        value =
          if not v.nil? and v != ''
            v
          else
            '(unset)'
          end
        "#{human_name}: #{value}"
      end.join("\n")
    end

    def each_configuration(&block)
      target.class::CONFIGURATION.map do |key|
        human_name = key.to_s.gsub('_', ' ')
        block.call(key, human_name)
      end
    end

    private

    def display_pairs
      [['name', name]] + config_pairs
    end

    def config_pairs
      each_configuration do |key, human_name|
         [human_name, config[key]]
      end
    end
  end
end

