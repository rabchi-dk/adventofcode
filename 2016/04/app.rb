require_relative 'lib/solver'
require_relative 'lib/challenge'

input = Challenge.new.input

solver = Solver.new
puts "-- Part 1: --"
puts solver.solve_part1(input)

second_solver = Solver.new
puts "-- Part 1: --"
puts second_solver.solve_part2(input)
