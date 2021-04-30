class SolveBooleanEquation
  def initialize(true_literal_variable, false_literal_variable, defects)
    @defects = defects
    @inverse_defects = reverse_defects
    @true_literal_variable = true_literal_variable
    @false_literal_variable = false_literal_variable
    @true_statement_faultless = faultless_statement(true_literal_variable)
    @false_statement_faultless = faultless_statement(false_literal_variable)
    @true_statement_defect = defect_statement(true_literal_variable)
    @false_statement_defect = defect_statement(false_literal_variable)
  end

  def solve; end

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
end
