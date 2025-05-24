# frozen_string_literal: true

# EvaluateNumber is just an example of different ways to use the all?
# methods. Same applies to any number of enumerator methods like any? or none?
class EvaluateNumber
  def self.how_you_often_see_it(first_number, second_number)
    [first_number, second_number].all? do |thing| # rubocop:disable Performance/RedundantEqualityComparisonBlock
      thing.is_a?(Number)
    end
  end

  # Best way obviously!
  def self.using_a_class(first_number, second_number)
    [first_number, second_number].all?(Integer)
  end

  # Passing a method that return a lambda
  # It's nice because you can leverage the ? and ! convention :)
  def self.passing_a_method(first_number, second_number)
    [first_number, second_number].all?(&:integer?)
  end

  def integer?
    lambda do |thing|
      thing.is_a?(Integer)
    end
  end

  # Using a lambda
  # can't use ! and ? in variables though
  def self.using_a_lambda(first_number, second_number)
    is_integer = lambda do |thing|
      thing.is_a?(Integer)
    end

    [first_number, second_number].all?(&is_integer)
  end
end

# Passing a method with a lambda
puts EvaluateNumber.how_you_often_see_it(1, 2)
puts EvaluateNumber.using_a_class(1, 2)
puts EvaluateNumber.passing_a_method(1, 2)
puts EvaluateNumber.using_a_lambda(1, 2)
