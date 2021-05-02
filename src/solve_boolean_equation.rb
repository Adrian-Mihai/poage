require_relative 'utils/inputs'

class SolveBooleanEquation
  attr_writer :equation

  def initialize(primary_inputs, equation)
    @primary_inputs = primary_inputs
    @equation = equation
  end

  def solve
    inputs = Inputs.generate(@primary_inputs)
    solutions = []
    inputs.each do |input|
      equation = replace_inputs(input, @equation)

      arguments = equation.split(' + ')
      arguments.map! { |argument| argument.include?('0') ? '0' : '1' }
      solutions << input if arguments.include?('1')
    end
    solutions
  end

  private

  def replace_inputs(input, equation)
    boolean_equation = String.new(equation)
    input.keys.each do |key|
      boolean_equation.gsub!("/#{key}", input[key].to_i.zero? ? '1' : '0')
      boolean_equation.gsub!(key, input[key])
    end
    boolean_equation
  end
end
