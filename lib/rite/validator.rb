# frozen_string_literal: true

# @private
module Rite
  # Validator handles logic for validating a value
  class Validator
    def self.validate(*)
      raise NotImplementedError, 'validate is not implemented yet'
    end

    def self.valid?(value)
      !!validate(value) # rubocop:disable Style/DoubleNegation
    end

    def self.failure_message(*)
      'value failed validation'
    end
  end

  # @private
  class ValidatorDefinition
    attr_reader :klass

    def initialize
      @klass = Class.new(Validator)
    end

    def on_validate(&block)
      raise ArgumentError, 'block to #on_validate should accept one argument' if block.arity.abs != 1
      @klass.define_singleton_method(:validate, &block)
    end

    def failure_message(&block)
      raise ArgumentError, 'block to #on_validate should accept one argument' if block.arity.abs != 1
      @klass.define_singleton_method(:failure_message, &block)
    end
  end

  def self.define_validator(&block)
    definition = ValidatorDefinition.new
    definition.instance_eval(&block)
    definition.klass
  end
end
