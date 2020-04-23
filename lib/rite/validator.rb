# frozen_string_literal: true

# @private
module Rite
  # Validator handles logic for validating a value
  class Validator
    def self.validate(_value, *_args)
      raise NotImplementedError, 'validate is not implemented yet'
    end

    def self.validate!(value, *args)
      raise Rite::ValidationError, failure_message(value, *args) unless validate(value, *args)
      true
    end

    def self.handle_error(error, _value, *_args)
      raise error
    end

    def self.valid?(value, *args)
      validate(value, *args)
    rescue StandardError => e
      handle_error(e)
      false
    end

    def self.failure_message(value, *_args)
      %("#{value}" failed validation)
    end
  end
end

# [
#   {
#     validator: ClassValidator,
#     arguments: [String],
#   },
# ]
