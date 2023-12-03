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

result = solver.solve(input_challenge)
puts result
raise "NO!" if [8474516, 8349125, 8472290].include?(result)
