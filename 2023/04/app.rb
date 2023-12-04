require_relative 'lib/challenge'
require 'debug'

CardGameResult = Struct.new(:number_of_wins, :score)

class Solver
  def solve_part2(input)
    lines = input.split("\n").collect { |line| [1, solve_line(line).number_of_wins] }

    lines.each.with_index do |(reps, number_of_wins), index|
      ending_index = [index+number_of_wins, lines.length-1].min
      ((index+1)..(ending_index)).each do |ii|
        lines[ii][0] = lines[ii][0] + reps
      end
    end

    return lines.collect { |reps, number_of_wins| reps }.sum
  end

  def solve_part1(input)
    sum = 0

    input.split("\n").each.with_index do |line, index|
      card_game_result = solve_line(line)
      sum = sum + card_game_result.score
    end

    sum
  end

  def solve_line(line)
    header, line = line.split(":")
    winning, draw = line.split("|").collect { |string_part| string_part.scan(/[0-9]+/).collect { |n| n.to_i } }

    interesting_nums = winning.intersection(draw)

    score = 0
    if interesting_nums.length == 1
      score = 1
    elsif interesting_nums.length > 1
      score = 2 ** (interesting_nums.length-1)
    end

    CardGameResult.new(interesting_nums.length, score)
  end
end

input_challenge = Challenge.new.input

input_example = "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"

result_part1 = Solver.new.solve_part1(input_challenge)
puts result_part1

result_part2 = Solver.new.solve_part2(input_challenge)
puts result_part2
