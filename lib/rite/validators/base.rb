# frozen_string_literal: true

module Rite
  module Validators
    # Validates a value based on a set of requirements.
    class Base
      class << self
        attr_reader :refinement_definitions

        # Defines a new refinment of this validator. A refinement is an
        # additional test that must pass in order for a value to be considered
        # valid. Examples of refinments are things like, string/array length,
        # numericality of a number, etc.
        def refinement(name, &block)
          @refinement_definitions ||= {}
          @refinement_definitions[name] = Rite::Refinement.build(&block)

          define_method(name) do |*args, **kwargs|
            with_refinement(name, Rite::Refinement::Args.new(args, kwargs))
          end
        end
      end

      # Constructs a new instance of the validator with a custom error message.
      def initialize(message:)
        self.refinements = []
        self.message = message
      end

      # Parses a given value against the defined validation logic.
      def parse(value)
        parsed = parse!(value)
        Rite::Result.success(parsed)
      rescue Rite::Error => e
        Rite::Result.failed(e)
      end

      # Parses a given value against the defined validation logic, raising an
      # error if the value doesn't match the requirements.
      # @param value [Object] the data that should be validated against.
      # @raise [Rite::Error] if any validation requirements are not met.
      def parse!(value)
        context = Rite::Context.new(value:, path: [])
        execute(context)
        context.value
      end

      # Configures the validator to be optional. An optional validator is
      # successful even if it receives the value nil.
      # @param message [#to_s] a custom error message to use if the value
      def optional
        Passage.of(
          Optional.new,
          self,
        )
      end

      # Determines if this validator should replace the validator given.
      def overwrite?(_other_validator)
        false
      end

      # Executes the refinements defined against the context.
      def execute(context)
        refinements.each do |(name, args)|
          context.check(self.class.refinement_definitions[name], args)
        end
        raise Rite::Error.new(context.issues) if context.issues.size > 0
        context
      end

      protected

      attr_accessor :refinements, :message

      # Constructs a new instance of this validator with the given refinement
      # configured with it's arguments.
      # @param refinement [Symbol] The name of the refinement specified.
      def with_refinement(refinement_name, args)
        next_schema = dup
        next_schema.refinements = refinements + [[refinement_name, args]]
        next_schema
      end
    end
  end
end
