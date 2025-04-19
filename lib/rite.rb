# frozen_string_literal: true

require 'rite/context'
require 'rite/error'
require 'rite/issue'
require 'rite/messages'
require 'rite/refinement'
require 'rite/result'
require 'rite/validators/base'
require 'rite/validators/passage'
require 'rite/validators/optional'
require 'rite/validators/instance'
require 'rite/validators/string'
require 'rite/version'

module Rite
  class << self
    def string(message: nil)
      Rite::Validators::String.new(message:)
    end
  end
end
