require_relative 'logic_gates'

class OutputStatements
  attr_reader :statements

  def elaborate(expression)
    @statements ||= {}

    @statements[expression.first] = elaborate_literal_variables(expression.first, expression.last)
    self
  end

  private

  def elaborate_literal_variables(node, logic_gate)
    gate, inputs = logic_gate.split(/[()]/)
    inputs = inputs.split(',')

    return { "P(#{node})": "#{inputs.first}(#{node}1)", "P'(#{node})": "/#{inputs.first}(#{node}0)" } if input?(gate)

    {
      "P(#{node})": elaborate_literal_variable(node, gate, inputs, :'1'),
      "P'(#{node})": elaborate_literal_variable(node, gate, inputs, :'0')
    }
  end

  def input?(gate)
    gate.casecmp?('INPUT')
  end

  def elaborate_literal_variable(node, gate, inputs, state)
    raw_expression = LogicGates.truth_table[gate.to_sym][state]
    if raw_expression.include?(' ⋅ ')
      right_argument, left_argument = raw_expression.split(' ⋅ ')
      elaborate_right_argument(right_argument, node, inputs.first, state)
      elaborate_left_argument(left_argument, node, inputs.last, state)

      return apply_boolean_algebra(right_argument, left_argument)
    end

    elaborate_right_argument(raw_expression, node, inputs.first, state)
    elaborate_left_argument(raw_expression, node, inputs.last, state)
    raw_expression
  end

  def elaborate_right_argument(expression, node, input, state)
    expression.gsub!("A'", elaborate_false_expression(node, input, state)) ||
      expression.gsub!('A', elaborate_true_expression(node, input, state))
  end

  def elaborate_left_argument(expression, node, input, state)
    expression.gsub!("B'", elaborate_false_expression(node, input, state)) ||
      expression.gsub!('B', elaborate_true_expression(node, input, state))
  end

  def apply_boolean_algebra(right_argument, left_argument)
    right_arguments = right_argument.split(' + ')
    left_arguments = left_argument.split(' + ')

    return "#{right_arguments.first} ⋅ #{left_arguments.first}" if right_arguments.size == 1 && left_arguments.size == 1

    expression = ''
    right_arguments.each do |r_argument|
      left_arguments.each do |l_argument|
        expression << r_argument + ' ⋅ ' + l_argument + ' + '
      end
    end

    expression.delete_suffix(' + ')
  end

  def elaborate_true_expression(node, input, state)
    @statements.dig(input.to_sym, :"P(#{input})")&.gsub(')', ", #{node}#{state})")
  end

  def elaborate_false_expression(node, input, state)
    @statements.dig(input.to_sym, :"P'(#{input})")&.gsub(')', ", #{node}#{state})")
  end
end
