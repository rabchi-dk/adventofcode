require 'pp'
require 'debug'
require_relative 'lib/challenge'

# Example
# input = "cpy 41 a
# inc a
# inc a
# dec a
# jnz a 2
# dec a
# "

input = Challenge.new.input

instructions = input.split("\n").collect do |line|
  line
end

slice_index = 0
while slice_index < instructions.length
  a,b,c,d,e,f = instructions.slice(slice_index, 6)

  if (inc_match = /^inc ([a-z]+)$/.match(a)) && (dec_match = /^dec ([a-z]+)$/.match(b)) && (jnz_match = /^jnz ([a-z]+) -2$/.match(c))
    # puts "Found -2 loop!"
    # pp [a,b,c]
    # pp [inc_match[1], dec_match[1], jnz_match[1]]
    if dec_match[1] == jnz_match[1]
      instructions[slice_index] = "%nop"
      instructions[slice_index + 1] = "%nop"
      instructions[slice_index + 2] = "%magic2 " + inc_match[1] + " " + dec_match[1]
      slice_index = 0 # Start over
    else
      raise "Failed to handle -2 loop"
    end
  # elsif (dec_match = /^dec ([a-z]+)$/.match(e)) && (jnz_match = /^jnz ([a-z]+) -5$/.match(f))
  #   # puts "Found -5 loop!"
  #   # pp [a,b,c,d,e,f]
  #   # pp [dec_match[1], jnz_match[1]]
  #   # instructions[slice_index] = "%nop"
  #   # instructions[slice_index + 1] = "%nop"
  #   # instructions[slice_index + 2] = "%nop"
  #   # instructions[slice_index + 3] = "%nop"
  #   instructions[slice_index + 4] = "%nop"
  #   instructions[slice_index + 5] = "%magic5 " + dec_match[1] + " " + jnz_match[1]
  #   slice_index = 0 # Start over
  else
    slice_index = slice_index + 1
  end
end

# puts
# puts
# puts
# puts instructions.join("\n")
# puts
# puts
# puts

registers = Hash.new(0)
registers["c"] = 1 # Part 2
instruction_index = 0
while instruction_index < instructions.length
  instruction = instructions[instruction_index]
  proceed_to_next_instruction_after_execution = true

  puts "Executing instruction #{instruction} (#{instruction_index}). Registers before executing:"
  pp registers

  if m = /^cpy (\d+) ([a-z]+)$/.match(instruction)
    registers[m[2]] = m[1].to_i
  elsif m = /^cpy ([a-z]+) ([a-z]+)$/.match(instruction)
    registers[m[2]] = registers[m[1]]
  elsif m = /^inc ([a-z]+)$/.match(instruction)
    registers[m[1]] = registers[m[1]] + 1
  elsif m = /^dec ([a-z]+)$/.match(instruction)
    registers[m[1]] = registers[m[1]] - 1
  elsif m = /^jnz (\d+) (\d+)$/.match(instruction)
    if m[1].to_i > 0
      instruction_index = instruction_index + m[2].to_i
      proceed_to_next_instruction_after_execution = false
    end
  elsif m = /^jnz ([a-z]+) (-?\d+)$/.match(instruction)
    if registers[m[1]] > 0
      # puts "Before jump: #{instruction_index} (#{m[2].to_i})"
      instruction_index = instruction_index + m[2].to_i
      # puts "After jump: #{instruction_index}"
      proceed_to_next_instruction_after_execution = false
    end
  elsif m = /^%nop$/.match(instruction)
    # Do nothing
  elsif m = /^%magic2 ([a-z]+) ([a-z]+)$/.match(instruction)
    registers[m[1]] = registers[m[1]] + registers[m[2]]
    registers[m[2]] = 0
  else
    raise "Unknown instruction: #{instruction}!"
  end

  instruction_index = instruction_index + 1 if proceed_to_next_instruction_after_execution
end

pp registers
