# frozen_string_literal: true

describe CaseFormatter do
  let(:instance) { Class.new { include CaseFormatter }.new }

  describe '#snake_to_camel_case' do
    context 'when input is a string' do
      it 'converts snake_case to camelCase' do
        expect(instance.snake_to_camel_case('hello_world')).to eq('helloWorld')
      end
    end

    context 'when input is a symbol' do
      it 'converts snake_case to camelCase' do
        expect(instance.snake_to_camel_case(:hello_world)).to eq(:helloWorld)
      end
    end

    context 'when input is a hash' do
      it 'converts all keys from snake_case to camelCase' do
        input = { first_name: 'John', last_name: 'Doe' }
        expected = { firstName: 'John', lastName: 'Doe' }
        expect(instance.snake_to_camel_case(input)).to eq(expected)
      end

      it 'converts nested hash keys' do
        input = { user_data: { first_name: 'John', address_info: { street_name: 'Main' } } }
        expected = { userData: { firstName: 'John', addressInfo: { streetName: 'Main' } } }
        expect(instance.snake_to_camel_case(input)).to eq(expected)
      end
    end

    context 'when input is an array' do
      it 'converts all elements that can be converted' do
        input = ['hello_world', { user_name: 'john' }, :test_case]
        expected = ['helloWorld', { userName: 'john' }, :testCase]
        expect(instance.snake_to_camel_case(input)).to eq(expected)
      end
    end

    context 'when input is another type' do
      it 'raises ArgumentError for nil' do
        expect { instance.snake_to_camel_case(nil) }
          .to raise_error(ArgumentError, 'Unexpected type for case conversion: NilClass')
      end

      it 'raises ArgumentError for numbers' do
        expect { instance.snake_to_camel_case(123) }
          .to raise_error(ArgumentError, 'Unexpected type for case conversion: Integer')
      end

      it 'raises ArgumentError for custom objects' do
        custom_object = OpenStruct.new(name: 'test')
        expect { instance.snake_to_camel_case(custom_object) }
          .to raise_error(ArgumentError, 'Unexpected type for case conversion: OpenStruct')
      end
    end
  end

  describe '#camel_to_snake_case' do
    context 'when input is a string' do
      it 'converts camelCase to snake_case' do
        expect(instance.camel_to_snake_case('helloWorld')).to eq('hello_world')
      end
    end

    context 'when input is a symbol' do
      it 'converts camelCase to snake_case' do
        expect(instance.camel_to_snake_case(:helloWorld)).to eq(:hello_world)
      end
    end

    context 'when input is a hash' do
      it 'converts all keys from camelCase to snake_case' do
        input = { firstName: 'John', lastName: 'Doe' }
        expected = { first_name: 'John', last_name: 'Doe' }
        expect(instance.camel_to_snake_case(input)).to eq(expected)
      end

      it 'converts nested hash keys' do
        input = { userData: { firstName: 'John', addressInfo: { streetName: 'Main' } } }
        expected = { user_data: { first_name: 'John', address_info: { street_name: 'Main' } } }
        expect(instance.camel_to_snake_case(input)).to eq(expected)
      end
    end

    context 'when input is an array' do
      it 'converts all elements that can be converted' do
        input = ['helloWorld', { userName: 'john' }, :testCase]
        expected = ['hello_world', { user_name: 'john' }, :test_case]
        expect(instance.camel_to_snake_case(input)).to eq(expected)
      end
    end

    context 'when input is another type' do
      it 'raises ArgumentError for nil' do
        expect { instance.snake_to_camel_case(nil) }
          .to raise_error(ArgumentError, 'Unexpected type for case conversion: NilClass')
      end

      it 'raises ArgumentError for numbers' do
        expect { instance.snake_to_camel_case(123) }
          .to raise_error(ArgumentError, 'Unexpected type for case conversion: Integer')
      end

      it 'raises ArgumentError for custom objects' do
        custom_object = OpenStruct.new(name: 'test')
        expect { instance.snake_to_camel_case(custom_object) }
          .to raise_error(ArgumentError, 'Unexpected type for case conversion: OpenStruct')
      end
    end
  end
end
