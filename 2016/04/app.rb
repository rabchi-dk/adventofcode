require_relative 'lib/solver'
require_relative 'lib/challenge'

input = Challenge.new.input

solver = Solver.new
puts "-- Part 1: --"
puts solver.solve(input)
