# frozen_string_literal: true

require 'intercept/strategy/replace'
require 'intercept/strategy/mapper'
require 'intercept/strategy/white_list'

module Intercept
  # Base class of the intercept module.
  # A worker object is responsible to intercept and modify state of registering class's objects
  class Worker
    attr_reader :interceptor_map, :decorator_map

    # @param registration_method [String, Symbol] method_name which is called by the registering class.
    # @param interceptor_map [Hash] Keys represent fields to be modified. Values are Strategy class object
    # @param decorator_map [Hash] Keys represent fields to be modified. Values are Decorator class object
    def initialize(registration_method, interceptor_map = {}, decorator_map = {})
      @interceptor_map = interceptor_map
      @decorator_map = decorator_map

      if registration_method != 'intercept' && registration_method != :intercept
        define_singleton_method(registration_method) { |message| delivering_message(message) }
      end
    end

    # This method is called when we want to intercept and modify an object.
    # 'registration_method' parameter of initialize is an alias to this method.
    # @param message is an object of any registering class
    def intercept(message)
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
