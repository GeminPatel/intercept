module Intercept
  module Decorator
    class AddSuffix
      attr_reader :suffix

      def initialize(suffix)
        @suffix = parse_suffix suffix
      end

      def decorate(value)
        return value unless String === value

        "#{value}#{suffix.call}"
      end

      private

      def parse_suffix(suffix)
        if suffix.respond_to?(:call)
          suffix
        else
          raise '@param suffix must respond to #call'
        end
      end
    end
  end
end