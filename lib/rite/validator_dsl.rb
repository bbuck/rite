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

    def define_validator_method(name, &block)
      if block.arity.abs < VALIDATOR_METHOD_ARITY
        raise Rite::DSLError, "validate method requires #{VALIDATOR_METHOD_ARITY} argument"
      end

      @klass.class_eval do
        define_singleton_method(name) do |value, args = []|
          block.call(value, *args)
        end
      end

      nil
    end
  end

  def self.define_validator(&block)
    ValidatorDSL.call(&block)
  end
end
