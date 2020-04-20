# frozen_string_literal: true

require 'rite/version'
require 'rite/validator'
require 'rite/validator_dsl'

module Rite
  class Error < StandardError; end
  class ValidationError < Error; end
  class DSLError < Error; end
  # Your code goes here...
end
