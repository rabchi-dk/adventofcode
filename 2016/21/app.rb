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
    input.slice(0, x) + input[x..y].reverse + input[(y+1)..-1]
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

example_instructions = "swap position 4 with position 0
swap letter d with letter b
reverse positions 0 through 4
rotate left 1 step
move position 1 to position 4
move position 3 to position 0
rotate based on position of letter b
rotate based on position of letter d"

scrambler = BunnyScrambler.new
after_step1 = scrambler.swap_position("abcde", 4, 0)
puts "after_step1: #{after_step1}"
after_step2 = scrambler.swap_letter(after_step1, "d", "b")
puts "after_step2: #{after_step2}"
after_step3 = scrambler.reverse_positions(after_step2, 0, 4)
puts "after_step3: #{after_step3}"
after_step4 = scrambler.rotate_left(after_step3, 1)
puts "after_step4: #{after_step4}"
after_step5 = scrambler.move_position(after_step4, 1, 4)
puts "after_step5: #{after_step5}"
after_step6 = scrambler.move_position(after_step5, 3, 0)
puts "after_step6: #{after_step6}"
after_step7 = scrambler.rotate_by_position_of_letter(after_step6, "b")
puts "after_step7: #{after_step7}"
after_step8 = scrambler.rotate_by_position_of_letter(after_step7, "d")
puts "after_step8: #{after_step8}"
