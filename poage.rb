require_relative 'src/logic_circuit'
require_relative 'src/output_statements'

if ARGV.size > 1
  puts 'To many arguments. Require 0 or 1'
  exit(1)
end

circuit_service = LogicCircuit.new(ARGV.empty? ? LogicCircuit::FILENAME : ARGV.first)

unless circuit_service.valid?
  puts circuit_service.errors
  exit(2)
end

logic_circuit = circuit_service.circuit

puts logic_circuit

output_statements_service = OutputStatements.new
logic_circuit.each { |expression| output_statements_service.elaborate(expression) }

output_statements_service.statements.each_value { |literal_variable| puts literal_variable }
