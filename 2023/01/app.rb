require_relative 'lib/challenge'
require 'debug'

class Solver
  DIGIT_MAP = {
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9",
  }

  def solve_part1(input)
    input.split("\n").collect { |line| solve_line_part1(line) }
  end

  def solve_line_part1(input)
    org_input = input.dup
    digits = input.scan(/[0-9]/)
    return 0 if digits.length == 0
    x = (digits.first + digits.last).to_i
    #pp [org_input, digits, x]
    return x
  end

  def solve_part2(input)
    input.split("\n").collect { |line| solve_line_part2(line) }
  end

  def solve_line_part2(input)
    org_input = input.dup
    digits = ([first_pseudo_digit(input)] + input.scan(/[0-9]/) + [last_pseudo_digit(input)]).compact
    return 0 if digits.length == 0
    x = (digits.first + digits.last).to_i
    #pp [org_input, digits, x]
    return x
  end

  def first_pseudo_digit(input)
    digit = nil

    if m = /^(.*?)(one|two|three|four|five|six|seven|eight|nine)/.match(input)
      before_digit = m[1]
      string_digit = m[2]
      digit = DIGIT_MAP[m[2]] unless /[0-9]/.match(before_digit)
    end

    digit
  end

  def last_pseudo_digit(input)
    digit = nil

    if m = /^(?:.*)(one|two|three|four|five|six|seven|eight|nine)(.*?)$/.match(input)
      string_digit = m[1]
      trailing_string = m[2]
      digit = DIGIT_MAP[m[1]] unless /[0-9]/.match(trailing_string)
    end

    digit
  end
end

input_challenge = Challenge.new.input

input_example = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"

solver = Solver.new
puts "Part 1:"
puts solver.solve_part1(input_challenge).inject(0) { |sum,v| sum = sum + v }
puts "Part 2:"
puts solver.solve_part2(input_challenge).inject(0) { |sum,v| sum = sum + v }
