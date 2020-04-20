# frozen_string_literal: true

require 'bigdecimal'
require 'spec_helper'

RSpec.describe Rite::Validator do
  subject(:validator) { described_class }

  describe '#validate' do
    it 'raises a not implemented error' do
      expect { validator.validate(nil) }.to raise_error(NotImplementedError)
    end
  end

  describe '#validate!' do
    it 'raises a not implemented error' do
      expect { validator.validate(nil) }.to raise_error(NotImplementedError)
    end
  end

  describe '#valid?' do
    it 'raises a not implemented error' do
      expect { validator.validate(nil) }.to raise_error(NotImplementedError)
    end
  end

  describe '#failure_message' do
    shared_examples_for 'error message' do |value|
      it "returns a default error message for #{value.class.name}" do
        expect(validator.failure_message(value)).to eq(%("#{value}" failed validation))
      end
    end

    # Fake custom object used to test validating custom types
    class Custom
      def to_s
        "<#{self.class.name}>"
      end
    end

    ['string', :symbol, 1001, 10.01, BigDecimal('1001.1001'), Custom.new].each do |value|
      it_behaves_like 'error message', value
    end
  end
end
