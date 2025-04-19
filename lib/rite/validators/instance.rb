# frozen_string_literal: true

module Rite
  module Validators
    # Validates that the value is of a specific instance.
    class Instance < Base
      def initialize(klass:, message: nil)
        super(message:)
        @klass = klass
      end

      # Validates that the value is of the expected type, if it is then it
      # continues validation.
      def execute(context)
        if !context.value.is_a?(::String)
          raise Rite::Error.new([
            Rite::TypeIssue.new(
              expected: klass.name,
              received: context.value.class.name,
              path: context.path,
              message:
            ),
          ])
        end
        super
      end

      def inspect_type
        klass.name
      end

      private

      attr_reader :klass
    end
  end
end
