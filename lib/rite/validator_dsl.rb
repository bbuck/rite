# frozen_string_literal: true

require 'rite/validator'

module Rite
  VALIDATOR_METHOD_ARITY = 1

  class ValidatorDSL
    def self.call(&block)
      builder = new
      builder.instance_eval(&block)
      builder.klass
    end

    attr_reader :klass

    def initialize
      @klass = Class.new(Rite::Validator)
    end

    def validate(&block)
      define_validator_method(:validate, &block)
    end

    def message(message = nil, &block)
      if block_given?
        define_validator_method(:failure_message, &block)
      else
        define_validator_method(:failure_message) do |value, _args = []|
          message.gsub(/%value/, value)
        end
      end
    end

    def rescue_with(method = nil, &block)
      if block_given?
        define_validator_method(:handle_error, &block)
      else
        case method
        when :reraising
          define_validator_method(:handle_error) do |error, *_args|
            raise error
          end
        when :ignoring
          define_validator_method(:handle_error) do |*_args|
            nil
          end
        when :wrapping
          define_validator_method(:handle_error) do |error, *_args|
            raise Rite::ValidationError, "#{error.class.name}: #{error.message}"
          end
        end
      end
    end

    def define_validator_method(name, &block)
      if block.arity.abs < VALIDATOR_METHOD_ARITY
        raise Rite::DSLError, "validate method requires #{VALIDATOR_METHOD_ARITY} argument"
      end

      @klass.define_singleton_method(name, &block)

      nil
    end
  end

  def self.define_validator(&block)
    ValidatorDSL.call(&block)
  end
end
