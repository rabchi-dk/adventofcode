require 'debug'
require_relative 'solver'

input = File.read("input_challenge.txt")

solver = SolverPart1.new
puts solver.solve(input)

