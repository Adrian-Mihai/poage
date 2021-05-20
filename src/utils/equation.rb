require_relative 'boolean_algebra'

class Equation
  attr_writer :defects

  def initialize(defects, statements)
    @defects = defects
    @true_statement = statements.first
    @inverse_statement = statements.last
    @true_statement_faultless = faultless_statement(@true_statement)
    @inverse_statement_faultless = faultless_statement(@inverse_statement)
  end

  def generate
    @inverse_defects = inverse_defects
    true_statement_defect = defect_statement(@true_statement)
    inverse_statement_defect = defect_statement(@inverse_statement)

    first_argument = BooleanAlgebra.apply(@inverse_statement_faultless, true_statement_defect)
    last_argument = BooleanAlgebra.apply(@true_statement_faultless, inverse_statement_defect)

    "#{first_argument} + #{last_argument}"
  end

  private

  def inverse_defects
    @defects.map { |defect| defect.include?('1') ? defect.gsub('1', '0') : defect.gsub('0', '1') }
  end

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
end
