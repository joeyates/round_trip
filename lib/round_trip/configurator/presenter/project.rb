require 'round_trip/configurator/presenter/base'

module RoundTrip
  module Configurator::Presenter; end

  class Configurator::Presenter::Project < Configurator::Presenter::Base
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

