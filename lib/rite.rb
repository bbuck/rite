# frozen_string_literal: true

require 'rite/context'
require 'rite/error'
require 'rite/issue'
require 'rite/messages'
require 'rite/refinement'
require 'rite/result'
require 'rite/validator'
require 'rite/validators/optional_validator'
require 'rite/validators/string_validator'
require 'rite/version'

module Rite
  class << self
    def string(message: nil)
      Rite::Validators::StringValidator.new(message:)
    end
  end
end
