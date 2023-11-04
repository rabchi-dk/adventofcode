require_relative 'lib/solver'

input = "cxdnnyjw"

solver = Solver.new
puts "-- Part 1: --"
puts solver.solve_part1(input)

second_solver = Solver.new
puts "-- Part 2: --"
puts second_solver.solve_part2(input)
