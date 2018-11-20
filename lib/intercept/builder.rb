require 'intercept/strategy/replace'
require 'intercept/strategy/mapper'
require 'intercept/strategy/white_list'

module Intercept
  class Builder
    attr_reader :interceptor_map, :decorator_map

    def initialize(registration_method, interceptor_map = {}, decorator_map = {})
      @interceptor_map = interceptor_map
      @decorator_map = decorator_map

      if registration_method != 'delivering_message' && registration_method != :delivering_message
        define_singleton_method(registration_method) { |message| delivering_message(message) }
      end
    end

    def delivering_message(message)
      interceptor_map.each do |field, strategy|
        if message.respond_to?(field) && message.respond_to?("#{field}=")
          message.public_send("#{field}=", strategy.process_identities(message.public_send field))
        end
      end

      decorator_map.each do |field, strategy|
        if message.respond_to?(field) && message.respond_to?("#{field}=")
          message.public_send("#{field}=", strategy.decorate(message.public_send field))
        end
      end
    end
  end
end
