# frozen_string_literal: true

module Intercept
  class StrategyBuilder
    def self.from_hash(strategy)
      return unless strategy
      strategy_class = get_class(strategy[:name])

      if fallback = Intercept::StrategyBuilder.from_hash(strategy[:fallback])
        strategy_class.new(strategy[:args], fallback)
      else
        strategy_class.new(strategy[:args])
      end
    end

    def self.get_class(symbol)
      "Intercept::Strategy::#{symbol.to_s.classify}".constantize
    end
  end
end
