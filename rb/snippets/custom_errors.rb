# frozen_string_literal: true

module CalculationErrors
  class InvalidOperandTypeError < ArgumentError
    def initialize(message = 'Operand can only be integers')
      super
    end
  end

  class UnsupportedOperation < StandardError
    def initialize(message = 'Operation is invalid')
      super
    end
  end

  class UnexpectedResultError < StandardError
    def initialize(message = 'The result of the calculation is unexpected or invalid.')
      super
    end
  end
end

class SimpleCalculator
  include CalculationErrors

  TEMPLATE = '%{first_operand} %{operation} %{second_operand} = %{result}'

  OPERATIONS = {
    addition: :+,
    multiplication: :*,
    division: :/,
    subtraction: :-
  }.freeze

  SUPPORTED_OPERATIONS = [OPERATIONS.values].freeze

  # --- Public class methods ---

  def self.calculate(first_operand, second_operand, operation)
    new(first_operand, second_operand, operation).to_s
  end

  # --- Attributes ---
  attr_reader :first_operand, :second_operand, :operation

  # --- Private methods ---
  private

  def initialize(first_operand, second_operand, operation)
    @first_operand = first_operand
    @second_operand = second_operand
    @operation = operation
    validate!
  end

  def validate!
    validate_operands!
    validate_operator!
    validate_operation!
  end

  def validate_operands!
    return true if [first_operand, second_operand].all?(Integer)

    raise InvalidOperandTypeError, "Operands must be integers. Received: [#{first_operand}, #{second_operand}]"
  end

  def validate_operator!
    raise UnsupportedOperation, "Unsupported operation: #{operation}" unless SUPPORTED_OPERATIONS.include?(operation)

    true
  end

  def validate_operation!
    raise ZeroDivisionError if division_by_zero?

    true
  end

  def division?
    @operation == OPERATIONS[:division]
  end

  def division_by_zero?
    division? && @second_operand.zero?
  end

  def result
    [first_operand, second_operand].reduce(operation.to_sym)
  rescue StandardError => e
    raise UnexpectedResultError, "Unexpected error: #{e.class} - #{e.message}"
  end

  def format_result
    format(TEMPLATE, first_operand:, operation:, second_operand:, result:)
  end

  # --- Public instance methods
  public

  def to_s
    format_result
  end
end

if $PROGRAM_NAME == __FILE__
  # Some guy: "I have this really cool library, and I wanted to add subtraction..."
  SimpleCalculator::SUPPORTED_OPERATIONS << '-'
  puts 'Modified the SUPPORTED_OPERATIONS:'
  puts SimpleCalculator::SUPPORTED_OPERATIONS

  SimpleCalculator.calculate(1, 2, '-')
  calculation = SimpleCalculator.new(1, 2, '-')
  puts calculation
  puts calculation
  puts calculation.result
end
