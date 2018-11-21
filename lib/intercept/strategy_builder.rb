# frozen_string_literal: true

module Intercept
  class StrategyBuilder
    def self.from_hash(hash)
      return unless hash

      strategy = hash[:strategy]
      strategy_class = get_class(strategy[:name])
      properties = strategy[:properties]

      if fallback = Intercept::StrategyBuilder.from_hash(properties[:fallback])
        strategy_class.new(properties[:args], fallback)
      else
        strategy_class.new(properties[:args])
      end
    end

    def self.get_class(symbol)
      "Intercept::Strategy::#{symbol.to_s.classify}".constantize
    end
  end
end
