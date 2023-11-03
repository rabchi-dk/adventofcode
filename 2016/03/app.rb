require_relative 'lib/solver'

solver = Solver.new
puts "-- Part 1: --"
puts solver.solve

second_solver = SecondSolver.new
puts "-- Part 2: --"
puts second_solver.solve
