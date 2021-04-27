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
      "P(#{node})": compose_data(node, gate, inputs, :'1'),
      "P'(#{node})": compose_data(node, gate, inputs, :'0')
    }
  end

  def input?(gate)
    gate.casecmp?('INPUT')
  end

  def compose_data(node, gate, inputs, state)
    raw_expression = LogicGates.truth_table[gate.to_sym][state]
    raw_expression.gsub!("A'", compose_false_expression(node, inputs.first, state))
    raw_expression.gsub!("B'", compose_false_expression(node, inputs.last, state))
    raw_expression.gsub!('A', compose_true_expression(node, inputs.first, state))
    raw_expression.gsub!('B', compose_true_expression(node, inputs.last, state))
    raw_expression
  end

  def compose_true_expression(node, input, state)
    @statements.dig(input.to_sym, :"P(#{input})")&.gsub(')', ", #{node}#{state})")
  end

  def compose_false_expression(node, input, state)
    @statements.dig(input.to_sym, :"P'(#{input})")&.gsub(')', ", #{node}#{state})")
  end
end
