# frozen_string_literal: true

module Rite
  module Validators
    class OptionalValidator < Validator
      def initialize(validator:, message:)
        self.validator = validator
        self.message = message
      end

      protected

      attr_accessor :validator, :message

      def execute(context)
        return if context.value.nil?
        validator.execute(context)
      end
    end
  end
end
