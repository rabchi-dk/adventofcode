require_relative 'lib/challenge'
require 'debug'

class Solver
  def initialize
  end

  def solve_part2(input)
    lines = input.split("\n").collect { |line| [1, nil, line] }

    lines.each.with_index do |(reps, cached_wins, line), index|
      num_wins = cached_wins
      reps.times do
        if num_wins.nil?
          num_wins, score = solve_line(line)
          if lines[index][1].nil?
            lines[index][1] = num_wins
          end
        end
        ending_index = [index+num_wins, lines.length-1].min
        ((index+1)..(ending_index)).each do |ii|
          lines[ii][0] = lines[ii][0] + 1
        end
      end
    end

    return lines.collect { |reps, cached_wins, line| reps }.sum
  end

  def solve_part1(input)
    sum = 0
    input.split("\n").each.with_index do |line, index|
      num_wins, line_score = solve_line(line)
      sum = sum + line_score
    end
    sum
  end

  def solve_line(line)
    header, line = line.split(":")
    winning_s, draw_s = line.split("|")
    winning = winning_s.scan(/[0-9]+/).collect { |n| n.to_i }
    draw = draw_s.scan(/[0-9]+/).collect { |n| n.to_i }

    interesting_nums = winning.intersection(draw)

    score = 0
    if interesting_nums.length == 1
      score = 1
    else
      score = 1
      (interesting_nums.length-1).times do |n|
        score = score * 2
      end
    end

    [interesting_nums.length, score]
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
