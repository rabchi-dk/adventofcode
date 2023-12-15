require_relative 'solver'

input = File.read("input_challenge.txt")

solver = SolverPart2.new
result = solver.solve(input)
puts "Part 2:"
puts result
