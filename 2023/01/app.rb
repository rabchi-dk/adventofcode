require_relative 'lib/challenge'

class NumberScannerPart1
  def scan(input)
    input.scan(/[0-9]/)
  end
end

class NumberScannerPart2
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

  def scan(input)
    input
      .scan(/(?=([0-9]|#{DIGIT_MAP.keys.join("|")}))/)
      .collect { |groups| groups[0] }
      .collect { |digit_match| DIGIT_MAP[digit_match] || digit_match }
  end
end

class Solver
  def initialize(scanner)
    @scanner = scanner
  end

  def solve(input)
    input
      .split("\n")
      .collect { |line| @scanner.scan(line) }
      .reject { |digits| digits.empty? }
      .collect { |digits| (digits.first + digits.last).to_i }
      .inject(0) { |sum, v| sum = sum + v }
  end
end

input_challenge = Challenge.new.input

input_example_part1 = "1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"

input_example_part2 = "two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"

puts "Part 1:"
part1_solution = Solver.new(NumberScannerPart1.new).solve(input_challenge)
puts part1_solution

puts "Part 2:"
part2_solution = Solver.new(NumberScannerPart2.new).solve(input_challenge)
puts part2_solution
