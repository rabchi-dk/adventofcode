require_relative 'solver'

input = File.read("input_challenge.txt")

solver = Solver.new
result = solver.solve_part2(input)
puts "Part 2:"
puts result
