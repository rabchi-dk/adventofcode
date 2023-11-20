require_relative 'lib/challenge'
require 'debug'

class BunnyScrambler
  def swap_position(input, x, y)
    temp = input[x]
    input[x] = input[y]
    input[y] = temp
    input
  end

  def swap_letter(input, x, y)
    input.tr("#{x}#{y}", "#{y}#{x}")
  end

  def reverse_positions(input, x, y)
    input[0, x] + input[x..y].reverse + input[(y+1)..-1]
  end

  def rotate_left(input, x)
    input.chars.rotate(x).join("")
  end

  def rotate_right(input, x)
    input.chars.rotate(x * -1).join("")
  end

  def move_position(input, from, to)
    temp = input[from]
    result = ""
    input.each_char.with_index do |c,i|
      if i == to
        result << (to > from ? c + temp : temp + c)
      elsif i != from
        result << c
      end
    end
    result
  end

  def rotate_by_position_of_letter(input, letter)
    index = input.index(letter)
    rotations = index + 1
    rotations = rotations + 1 if index >= 4
    rotations = rotations * -1 # Rotate right

    input.chars.rotate(rotations).join("")
  end
end

class BunnyInstructionsExecutor
  def initialize
    @scrambler = BunnyScrambler.new
  end
  attr_reader :scrambler

  def execute(input, instructions)
    #puts "input is: #{input}"
    instructions.split("\n").each do |line|
      #puts "lines is now: #{line}"
      if m = /^swap position ([0-9]+) with position ([0-9]+)$/.match(line)
        x = m[1].to_i
        y = m[2].to_i
        input = scrambler.swap_position(input, x, y)
      elsif m = /^swap letter ([a-z]) with letter ([a-z])$/.match(line)
        x = m[1]
        y = m[2]
        input = scrambler.swap_letter(input, x, y)
      elsif m = /^reverse positions ([0-9]+) through ([0-9]+)$/.match(line)
        x = m[1].to_i
        y = m[2].to_i
        input = scrambler.reverse_positions(input, x, y)
      elsif m = /^rotate left ([0-9]+) steps?$/.match(line)
        x = m[1].to_i
        input = scrambler.rotate_left(input, x)
      elsif m = /^rotate right ([0-9]+) steps?$/.match(line)
        x = m[1].to_i
        input = scrambler.rotate_right(input, x)
      elsif m = /^move position ([0-9]+) to position ([0-9]+)$/.match(line)
        x = m[1].to_i
        y = m[2].to_i
        input = scrambler.move_position(input, x, y)
      elsif m = /^rotate based on position of letter ([a-z]+)$/.match(line)
        x = m[1]
        input = scrambler.rotate_by_position_of_letter(input, x)
      else
        raise "Parser error! (#{line})"
      end
      #puts "input is now: #{input}"
    end
    input
  end
end

# Example
# example_instructions = "swap position 4 with position 0
# swap letter d with letter b
# reverse positions 0 through 4
# rotate left 1 step
# move position 1 to position 4
# move position 3 to position 0
# rotate based on position of letter b
# rotate based on position of letter d"

# puts BunnyInstructionsExecutor.new.execute("abcde", example_instructions)



# Manually do example
# scrambler = BunnyScrambler.new
# before_step1 = "abcde"
# puts "before_step1: #{before_step1}"
# after_step1 = scrambler.swap_position(before_step1, 4, 0)
# puts "after_step1: #{after_step1}"
# after_step2 = scrambler.swap_letter(after_step1, "d", "b")
# puts "after_step2: #{after_step2}"
# after_step3 = scrambler.reverse_positions(after_step2, 0, 4)
# puts "after_step3: #{after_step3}"
# after_step4 = scrambler.rotate_left(after_step3, 1)
# puts "after_step4: #{after_step4}"
# after_step5 = scrambler.move_position(after_step4, 1, 4)
# puts "after_step5: #{after_step5}"
# after_step6 = scrambler.move_position(after_step5, 3, 0)
# puts "after_step6: #{after_step6}"
# after_step7 = scrambler.rotate_by_position_of_letter(after_step6, "b")
# puts "after_step7: #{after_step7}"
# after_step8 = scrambler.rotate_by_position_of_letter(after_step7, "d")
# puts "after_step8: #{after_step8}"



puts "-- Part 1: --"
input = Challenge.new.input
puts BunnyInstructionsExecutor.new.execute("abcdefgh", input)
