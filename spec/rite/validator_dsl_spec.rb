# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rite::ValidatorDSL do
  describe 'as a Class' do
    subject(:dsl_class) { described_class.new }

    describe '#validate' do
      it 'fails with a block with arity less than 1' do
        expect { dsl_class.validate { } }.to raise_error(Rite::DSLError, /requires 1 argument/i)
      end

      it 'accepts with a block with arity of 3' do
        expect { dsl_class.validate { |_one, _two, _three| } }.not_to raise_error
      end

      it 'accepts a block with arity of 2' do
        expect { dsl_class.validate { |_one, _two| } }.not_to raise_error
      end

      it 'accepts a block with one optional argument' do
        expect { dsl_class.validate { |_one, _two = 1| } }.not_to raise_error
      end

      it 'rejects a block with all optional arguments' do
        expect { dsl_class.validate { |_one = 1, _two = 2| } }.to raise_error(Rite::DSLError, /requires 1 argument/i)
      end

      context 'when passing a valid block' do
        let(:dsl_class) { described_class.new }

        subject(:validator) { dsl_class.klass }

        before do
          dsl_class.validate do |_value, is_valid|
            is_valid
          end
        end

        it 'defines a #validate method on the class' do
          expect(validator.validate(:value, true)).to eq(true)
          expect(validator.validate(:value, false)).to eq(false)
        end

        it 'enables #validate! to work' do
          expect { validator.validate!(:value, true) }.not_to raise_error
          expect { validator.validate!(:value, false) }.to raise_error(Rite::ValidationError)
        end

        it 'enables #valid? to work' do
          expect(validator.valid?(:value, true)).to eq(true)
          expect(validator.valid?(:value, false)).to eq(false)
        end
      end
    end

    describe '#message' do
      it 'fails with a block with arity less than 1' do
        expect { dsl_class.message { } }.to raise_error(Rite::DSLError, /requires 1 argument/i)
      end

      it 'accepts with a block with arity of 3' do
        expect { dsl_class.message { |_one, _two, _three| } }.not_to raise_error
      end

      it 'accepts a block with arity of 2' do
        expect { dsl_class.message { |_one, _two| } }.not_to raise_error
      end

      it 'accepts a block with one optional argument' do
        expect { dsl_class.message { |_one, _two = 1| } }.not_to raise_error
      end

      it 'rejects a block with all optional arguments' do
        expect { dsl_class.message { |_one = 1, _two = 2| } }.to raise_error(Rite::DSLError, /requires 1 argument/i)
      end

      it 'accepts a string' do
        expect { dsl_class.message('message') }.not_to raise_error
      end

      context 'when passing a valid block' do
        let(:dsl_class) { described_class.new }

        subject(:validator) { dsl_class.klass }

        before do
          dsl_class.message do |value, extra|
            "#{value} #{extra}"
          end
        end

        it 'defines a custom #failure_message method' do
          expect(validator.failure_message('value', 'extra')).to eq('value extra')
        end
      end

      context 'when passing just a string' do
        let(:dsl_class) { described_class.new }

        subject(:validator) { dsl_class.klass }

        before do
          dsl_class.message('%value static')
        end

        it 'defines a custom #failure_message method' do
          expect(validator.failure_message('value')).not_to eq(Rite::Validator.failure_message('value'))
        end

        it 'substitues %value with the value' do
          expect(validator.failure_message('testing')).to eq('testing static')
        end
      end
    end

    describe '#rescue_with' do
      it 'responds to #rescue_with' do
        expect(dsl_class).to respond_to(:rescue_with)
      end
    end

    describe '#fake_method' do
      it 'reponds to #fake_method' do
        expect(dsl_class).to respond_to(:fake_method)
      end
    end
  end

  describe 'with the DSL' do
    let(:validator) do
      Rite.define_validator do
        validate do |value, klass|
          value.is_a?(klass)
        end

        message do |value, klass|
          "#{value} expected to be #{klass.name}"
        end
      end
    end

    it 'validates value is of type' do
      expect(validator.validate('string', String)).to be_truthy
    end

    it 'does not validate value is of a different type' do
      expect(validator.validate('string', Numeric)).to be_falsey
    end

    it 'returns a custom error message' do
      validator.failure_message(10, String)
    end
  end
end
