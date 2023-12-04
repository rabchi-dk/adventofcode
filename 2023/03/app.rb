require_relative 'lib/challenge'
require 'debug'

class Solver
  def initialize(input)
    @symbols = input.gsub(/[0-9]|\.|\n/, "").chars.uniq
    @lines = input.split("\n")
    @max_rindex = @lines[0].length-1
    @max_cindex = @lines.length-1
  end

  def is_symbol?(char)
    @symbols.any? { |symbol| symbol == char }
  end

  def symbol_near?(index)
    neighbour_indices(index).any? { |row, col| is_symbol?(@lines[row][col]) }
  end

  def solve_part1
    sum = 0
    @lines.each.with_index do |line, rindex|
      is_good = false
      number = ""
      line.chars.each.with_index do |char, cindex|
        if /[0-9]/.match(char)
          number = number + char
          if symbol_near?([rindex, cindex])
            is_good = true
          end
        end
        if is_symbol?(char) || "." == char || cindex == line.length-1
          if is_good
            sum = sum + number.to_i
          end
          is_good = false
          number = ""
        end
      end
    end

    sum
  end

  def solve_part2
    gear_ratio_sum = 0

    interesting_symbol_locations = @lines.collect.with_index { |line, rindex|
      line.chars.collect.with_index { |char, i|
        neighbour_indices([rindex, i]) if char == "*" }.compact }.flatten(1)

    number_locations = @lines.collect.with_index { |line, rindex|
      line
        .to_enum(:scan, /[0-9]+/)
        .lazy
        .collect { |number| [rindex, Regexp.last_match.offset(0)[0]..Regexp.last_match.offset(0)[1]-1, number.to_i] }.to_a }.flatten(1)

    interesting_symbol_locations.each do |symbol_neighbour_locations|
      numbers_near_this_symbol = []
      symbol_neighbour_locations.each do |srow, scol|
        numbers_near_this_symbol = numbers_near_this_symbol + number_locations.select { |nrow, ncol, n| srow == nrow && ncol.include?(scol)}
      end
      numbers_near_this_symbol = numbers_near_this_symbol.uniq

      if numbers_near_this_symbol.length == 2
        gear_ratio_sum = gear_ratio_sum + numbers_near_this_symbol[0][2] * numbers_near_this_symbol[1][2]
      end
    end

    gear_ratio_sum
  end

  def neighbour_indices(index)
    [[-1, -1], [-1, 0], [-1, 1],
     [0, -1], [0, 0], [0, 1],
     [1, -1], [1, 0], [1, 1]]
      .collect { |drow, dcol| [index[0] + drow, index[1] + dcol] }
      .reject { |row, col| row > @max_rindex || col > @max_cindex || row < 0 || col < 0 }
  end
end

input_challenge = Challenge.new.input

input_example = "467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"

solver = Solver.new(input_challenge)

result_part1 = solver.solve_part1
puts result_part1
raise "incorrect" if 532331 != result_part1

result_part2 = solver.solve_part2
puts result_part2
raise "incorrect" if 82301120 != result_part2
