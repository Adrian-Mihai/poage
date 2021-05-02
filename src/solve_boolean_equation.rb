require_relative 'utils/inputs'
require_relative 'utils/boolean_algebra'

class SolveBooleanEquation

  attr_reader :solutions

  def initialize(primary_inputs, defects, true_literal_variable, false_literal_variable)
    @solutions = []
    @primary_inputs = primary_inputs
    @defects = defects
    @inverse_defects = reverse_defects
    @true_literal_variable = true_literal_variable
    @false_literal_variable = false_literal_variable
    @true_statement_faultless = faultless_statement(true_literal_variable)
    @false_statement_faultless = faultless_statement(false_literal_variable)
    @true_statement_defect = defect_statement(true_literal_variable)
    @false_statement_defect = defect_statement(false_literal_variable)
  end

  def solve
    inputs = Inputs.generate(@primary_inputs)
    equation = generate_equation
    inputs.each do |input|
      input.keys.each do |key|
        equation.gsub!("/#{key}", input[key].to_i.zero? ? '1' : '0')
        equation.gsub!(key, input[key])
      end

      arguments = equation.split(' + ')
      arguments.map! { |argument| argument.include?('0') ? '0' : '1' }
      solutions << input if arguments.include?('1')
      equation = generate_equation
    end
  end

  def defects=(value)
    @defects = value
    @inverse_defects = reverse_defects
    @true_statement_defect = defect_statement(@true_literal_variable)
    @false_statement_defect = defect_statement(@false_literal_variable)
  end

  private

  def faultless_statement(literal_variable)
    statement = String.new(literal_variable)
    arguments = literal_variable.split(/ ⋅ | \+ /)
    arguments.each do |argument|
      primary_input, = argument.split(/[()]/)
      statement.gsub!(argument, primary_input)
    end
    statement
  end

  def defect_statement(literal_variable)
    statement = String.new(literal_variable)
    arguments = literal_variable.split(/ ⋅ | \+ /)
    arguments.each do |argument|
      primary_input, variables = argument.split(/[()]/)
      variables = variables.gsub(' ', '').split(',').reverse!

      apply_rules(statement, argument, primary_input, variables)
    end
    statement
  end

  def apply_rules(statement, argument, primary_input, variables)
    variables.each do |variable|
      statement.gsub!(argument, '1') if @defects.include?(variable)
      statement.gsub!(argument, '0') if @inverse_defects.include?(variable)
    end
    statement.gsub!(argument, primary_input)
  end

  def reverse_defects
    @defects.map { |defect| defect.include?('1') ? defect.gsub('1', '0') : defect.gsub('0', '1') }
  end

  def generate_equation
    first_argument = BooleanAlgebra.apply(@false_statement_faultless, @true_statement_defect)
    last_argument = BooleanAlgebra.apply(@true_statement_faultless, @false_statement_defect)

    "#{first_argument} + #{last_argument}"
  end
end
