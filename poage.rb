require_relative 'src/logic_circuit'
require_relative 'src/output_statements'
require_relative 'src/solve_boolean_equation'
require_relative 'src/utils/equation'

if ARGV.empty?
  puts 'Require at least 1 input'
  exit(1)
end

read_circuit = LogicCircuit.new

unless read_circuit.valid?
  puts read_circuit.errors
  exit(2)
end

possible_errors = read_circuit.nodes.map { |node| %W[#{node}0 #{node}1] }
possible_errors.flatten!

unless ARGV.all? { |possible_error| possible_errors.include?(possible_error) }
  puts 'Invalid input'
  exit(3)
end

output_statements_service = OutputStatements.new
read_circuit.circuit.each { |expression| output_statements_service.elaborate(expression) }

last_node = read_circuit.nodes.last&.to_sym
statements = output_statements_service.statements[last_node].values

equation_service = Equation.new(ARGV, statements)
boolean_equation = SolveBooleanEquation.new(read_circuit.inputs, equation_service.generate)
puts boolean_equation.solve
