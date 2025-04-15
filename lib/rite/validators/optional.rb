# frozen_string_literal: true

module Rite
  module Validators
    class Optional < Base
      def initialize
        super(message: nil)
      end

      # Instructs validation of the context to stop if the value is nil,
      # which effectively allows nil values to be considered valid.
      def execute(context)
        context.halt if context.value.nil?
      end
    end
  end
end
