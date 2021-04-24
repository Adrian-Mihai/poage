require_relative 'src/logic_circuit'

if ARGV.size > 1
  puts 'To many arguments. Require 0 or 1'
  exit(1)
end

circuit = ARGV.empty? ? LogicCircuit.new : LogicCircuit.new(ARGV.first)

unless circuit.valid?
  puts circuit.errors
  exit(2)
end

puts circuit.circuit
