# frozen_string_literal: true

module Intercept
  class DecoratorBuilder
    def self.from_hash(decorator)
      return unless decorator
      decorator_class = get_class(decorator[:name])
      decorator_class.new(decorator[:args])
    end

    def self.get_class(symbol)
      Object.const_get "Intercept::Decorator::#{symbol.to_s.split('_').map{ |w| w.capitalize }.join}"
    end
  end
end