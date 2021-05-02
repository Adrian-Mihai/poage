require_relative 'src/logic_circuit'
require_relative 'src/output_statements'
require_relative 'src/solve_boolean_equation'
require_relative 'src/utils/equation'

if ARGV.size > 1
  puts 'To many arguments. Require 0 or 1'
  exit(1)
end

read_circuit = LogicCircuit.new(ARGV.empty? ? LogicCircuit::FILENAME : ARGV.first)

unless read_circuit.valid?
  puts read_circuit.errors
  exit(2)
end

logic_circuit = read_circuit.circuit

output_statements_service = OutputStatements.new
logic_circuit.each { |expression| output_statements_service.elaborate(expression) }

last_node = output_statements_service.statements.keys.last
statements = output_statements_service.statements[last_node].values

equation_service = Equation.new(['e0'], statements)
boolean_equation = SolveBooleanEquation.new(['x1', 'x2', 'x3', 'x4'], equation_service.generate)
puts boolean_equation.solve

equation_service.defects = ['a1', 'd1']
boolean_equation.equation = equation_service.generate
puts boolean_equation.solve
