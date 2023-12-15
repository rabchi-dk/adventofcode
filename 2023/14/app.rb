require 'debug'
require_relative 'lib'

input_challenge = File.read("input_challenge.txt")

solver_part1 = SolverPart1.new
puts "Part 1:"
puts solver_part1.solve(input_challenge)

solver_part2 = SolverPart2.new
puts "Part 2:"
puts solver_part2.solve(input_challenge)
