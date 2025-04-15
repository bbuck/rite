# frozen_string_literal: true

module Rite
  module Validators
    # Tracks a series of validations a value must pass before it succeeds.
    class Passage < Base
      class << self
        # Constructs a new Passage containing a new array of the items given.
        def of(*steps)
          passage = new
          passage.steps = steps
          passage
        end
      end

      attr_accessor :steps

      def initialize
        self.steps = []
      end

      # Adds a new step to the passage following the rules of the positional
      # hint. This constructs a new passage.
      # Supported positional hints:
      #  - :end - append to the list
      #  - :start - prepend to the list
      #  - :start_singleton - prepend to the list if the step is not already
      #    in the list.
      # @param step [Rite::Validators::Base] the step to add to the passage.
      # @param position_hint [Symbol] the positional hint to control how/where
      #   the step is added. Defaults to :end.
      def with_new_step(step, position_hint = :end)
        case position_hint
        when :end
          dup.tap do |passage|
            passage.steps = steps + [step]
          end
        when :start
          dup.tap do |passage|
            passage.steps = [step] + steps
          end
        when :start_singleton
          if steps.none? { |x| x.is_a?(step.class) }
            dup.tap do |passage|
              passage.steps = [step] + steps
            end
          else
            self
          end
        else
          raise ArgumentError, "unknown position hint #{position_hint} given"
        end
      end

      # Creates a new passage with an optional validator if not already present.
      def optional
        with_new_step(Optional.new, :start_singleton)
      end

      # Calls the missing method on the the last item if it responds to it, this
      # enables the passage to act as it's last item.
      def method_missing(name, *args, **kwargs, &block)
        last_step = steps.last
        if last_step && last_step.respond_to?(name)
          new_validator = last_step.send(name, *args, **kwargs, &block)
          return self if new_validator == last_step

          dup.tap do |passage|
            passage.steps = steps.dup.tap do |new_steps|
              new_steps.pop
              new_steps << new_validator
            end
          end
        else
          super
        end
      end

      # Determines if the last item in the passage can respond to the message.
      def respond_to_missing?(name, include_all = false)
        last_step = steps.last
        return last_step.respond_to?(name, include_all) if last_step
        super
      end

      # Evaluates each step in the passage in order, short circuiting if the
      # continuation should halt.
      def execute(context)
        steps.each do |step|
          break unless context.continue?
          step.execute(context)
        end
        unless context.valid?
          raise Rite::Error.new(context.issues)
        end
      end

      def inspect_type
        optional = false
        steps.flat_map do |step|
          if step.is_a?(Optional)
            optional = true
            []
          else
            ["#{step.inspect_type}#{optional ? '?' : ''}"]
          end
        end.join(' => ')
      end
    end
  end
end
