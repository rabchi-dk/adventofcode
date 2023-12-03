require_relative 'lib/challenge'
require 'debug'

class Solver
  SYMBOLS = ["-", "*", "&", "$", "@", "/", "#", "=", "%", "+"]
  def initialize
  end

  def is_symbol?(char)
    SYMBOLS.any? { |symbol| symbol == char }
  end

  def symbol_near?(lines, rindex, cindex)
    if cindex > 0 && is_symbol?(lines[rindex][cindex-1])
      true
    elsif cindex < lines[0].length-1 && is_symbol?(lines[rindex][cindex+1])
      true
    elsif cindex > 0 && rindex > 0 && is_symbol?(lines[rindex-1][cindex-1])
      true
    elsif rindex < lines.length-1 && rindex > 0 && is_symbol?(lines[rindex-1][cindex])
      true
    elsif cindex < lines[0].length-1 && rindex > 0 && is_symbol?(lines[rindex-1][cindex+1])
      true
    elsif cindex > 0 && rindex < lines.length-1 && is_symbol?(lines[rindex+1][cindex-1])
      true
    elsif rindex < lines.length-1 && is_symbol?(lines[rindex+1][cindex])
      true
    elsif cindex < lines[0].length-1 && rindex < lines.length-1 && is_symbol?(lines[rindex+1][cindex+1])
      true
    else
      false
    end
  end

  def solve(input)
    sum = 0
    lines = input.split("\n")
    lines.each.with_index do |line, rindex|
      #puts "line:#{line} (rindex:#{rindex})"
      is_good = false
      number = ""
      line.chars.each.with_index do |char, cindex|
        #debugger if 31 == cindex
        #puts "  char:#{char}"
        if /[0-9]/.match(char)
          number = number + char
          #puts "   number:#{number}"
          #debugger if "643" == number
          if symbol_near?(lines, rindex, cindex)
            is_good = true
          end
        end
        if is_symbol?(char) || "." == char || cindex == line.length-1
          if is_good
            puts " !!! Found good: #{number}"
            sum = sum + number.to_i
          else
            puts " !!! NOT GOOD: #{number}" if !number.empty?
          end
          is_good = false
          number = ""
        end
      end
    end

    sum
  end

  def solve_part2(input)
    gear_ratio_sum = 0

    result = 0
    lines = input.split("\n")
    max_rindex = lines[0].length-1
    max_cindex = lines.length-1

    interesting_symbol_locations = []
    lines.each.with_index do |line, rindex|
      stari = line.chars.collect.with_index { |c,i| i if c == "*" }.compact
      neighbouri = stari.collect { |i| enum_neighbour_indeces([rindex, i], max_rindex, max_cindex) }
      interesting_symbol_locations = interesting_symbol_locations + neighbouri
      #neighbours = neighbouri.collect { |x,y| [x, y, lines[x][y]] }.select { |x,y,c| /[0-9]/.match(c) }
    end

    number_locations = []
    lines.each.with_index do |line, rindex|
      i = 0
      while i < line.length-1 && m = /[0-9]+/.match(line, i)
        si, se = m.offset(0)
        se = se -1
        i = se + 1

        number_locations << [rindex, si..se, m[0].to_i]
      end
    end

    interesting_symbol_locations.each do |coll|
      result = []
      coll.each do |sx,sy|
        blah = number_locations.select { |nx, ny, n|
          sx == nx && ny.include?(sy)
        }
        result = result + blah
      end
      stuff = result.uniq
      if stuff.length == 2
        puts "#{stuff[0][2]} * #{stuff[1][2]}"
        tmp_gear_ratio = stuff[0][2] * stuff[1][2]
        gear_ratio_sum = gear_ratio_sum + tmp_gear_ratio
      end
    end

    gear_ratio_sum
  end

  def enum_neighbour_indeces(index, max_x, max_y)
    [[-1, -1], [-1, 0], [-1, 1],
     [0, -1], [0, 0], [0, 1],
     [1, -1], [1, 0], [1, 1]]
      .collect { |dx, dy| [index[0] + dx, index[1] + dy] }
      .reject { |x, y| x > max_y || y > max_y || x < 0 || y < 0 }
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

# symbols = input_challenge.gsub(/[0-9]|\.|\n/, "")
# pp symbols.chars.uniq
# exit

solver = Solver.new
# pp solver.enum_neighbour_indeces([2, 0], 3, 3)
# exit

result = solver.solve_part2(input_challenge)
puts result
raise "NO!" if [4375248].include?(result)
#raise "NO!" if [8474516, 8349125, 8472290].include?(result)
