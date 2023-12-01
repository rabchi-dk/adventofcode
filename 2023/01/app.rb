require_relative 'lib/challenge'
require 'debug'

class Solver
  def initialize
  end

  def solve(input)
    input.split("\n").collect { |line| solve_line(line) }
  end

  def solve_line(input)
    org_input = input.dup
    input = translate_digits(input)
    digits = input.scan(/[0-9]/)
    return 0 if digits.length == 0
    x = (digits.flatten[0] + digits.flatten[-1]).to_i
    pp [org_input, digits, x]
    return x
  end

  def translate_digits(input)
    map = {
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9,
      "ten" => 10,
    }

    reverse_map = {
      "one".reverse => 1,
      "two".reverse => 2,
      "three".reverse => 3,
      "four".reverse => 4,
      "five".reverse => 5,
      "six".reverse => 6,
      "seven".reverse => 7,
      "eight".reverse => 8,
      "nine".reverse => 9,
    }

    string_digit = nil
    digit = nil
    if m = /one|two|three|four|five|six|seven|eight|nine/.match(input)
      string_digit = m[0]
      digit = map[m[0]].to_s
    end
    if digit
      input = input.sub(string_digit, digit)
    end

    reverse_input = input.reverse
    reverse_string_digit = nil
    reverse_digit = nil
    if m = /enin|thgie|neves|xis|evif|ruof|eerht|owt|eno/.match(reverse_input)
      reverse_string_digit = m[0]
      reverse_digit = reverse_map[m[0]].to_s
    end
    if reverse_digit
      reverse_input = reverse_input.sub(reverse_string_digit, reverse_digit)
    end

    reverse_input.reverse
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

# pp solver.solve_line("lmscbrnlzmbqpl75ptwo64eightwoxcm")
# exit

result = solver.solve(input_challenge).inject(0) { |sum,v| sum = sum + v }
puts "Result is wrong" if [54251, 54775, 54235].include?(result)
pp result
