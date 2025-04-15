# frozen_string_literal: true

module Rite
  # Validates a value based on a set of requirements.
  class Validator
    class << self
      attr_reader :refinement_definitions

      def refinement(name, &block)
        @refinement_definitions ||= {}
        @refinement_definitions[name] = Rite::Refinement.build(&block)

        define_method(name) do |*args, **kwargs|
          with_refinement(name, { args:, kwargs: })
        end
      end
    end

    def initialize(message:)
      self.refinements = []
      self.message = message
    end

    def parse(value)
      parsed = parse!(value)
      Rite::Result.success(parsed)
    rescue Rite::Error => e
      Rite::Result.failed(e)
    end

    def parse!(value)
      context = Rite::Context.new(value:, path: [])
      execute(context)
      context.value
    end

    def optional(message: nil)
      Rite::Validators::OptionalValidator.new(
        validator: self,
        message:,
      )
    end

    protected

    attr_accessor :refinements, :message

    def execute(context)
      refinements.each do |(name, args)|
        context.check(self.class.refinement_definitions[name], args)
      end
      raise Rite::Error.new(context.issues) if context.issues.size > 0
      context
    end

    def with_refinement(refinement_name, args)
      next_schema = dup
      next_schema.refinements << [refinement_name, args]
      next_schema
    end
  end
end
