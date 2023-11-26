require 'debug'

class AssembunnyExecutor
  def initialize
    @registers = Hash.new(0)
  end

  def set_register(register_name, value)
    @registers[register_name] = value
  end

  def execute(instructions)
    optimized_instructions = optimize_instructions(instructions)

    instruction_index = 0
    while instruction_index < instructions.length
      instruction = optimized_instructions[instruction_index]
      proceed_to_next_instruction_after_execution = true

      puts "Executing instruction #{instruction} (#{instruction_index}). Registers before executing:"
      pp @registers
      puts ""
      puts "Instructions before executing:"
      optimized_instructions.each.with_index do |instruction, index|
        puts "#{sprintf('%2i', index)}: #{instruction}"
      end
      #STDIN.readline

      if m = /^cpy (-?\d+) ([a-z]+)$/.match(instruction)
        @registers[m[2]] = m[1].to_i
      elsif m = /^cpy ([a-z]+) ([a-z]+)$/.match(instruction)
        @registers[m[2]] = @registers[m[1]]
      elsif m = /^cpy (-?\d+) (-?\d+)$/.match(instruction)
        # Do nothing
      elsif m = /^cpy ([a-z]+) (-?\d+)$/.match(instruction)
        # Do nothing
      elsif m = /^inc ([a-z]+)$/.match(instruction)
        @registers[m[1]] = @registers[m[1]] + 1
      elsif m = /^dec ([a-z]+)$/.match(instruction)
        @registers[m[1]] = @registers[m[1]] - 1
      elsif m = /^(inc|dec) \d+$/.match(instruction)
        # Do nothing
      elsif m = /^jnz (\d+) (\d+)$/.match(instruction)
        if m[1].to_i > 0
          instruction_index = instruction_index + m[2].to_i
          proceed_to_next_instruction_after_execution = false
        end
      elsif m = /^jnz (\d+) ([a-z]+)$/.match(instruction)
        if m[1].to_i > 0
          instruction_index = instruction_index + @registers[m[2]]
          proceed_to_next_instruction_after_execution = false
        end
      elsif m = /^jnz ([a-z]+) ([a-z]+)$/.match(instruction)
        if @registers[m[1]] > 0
          instruction_index = instruction_index + @registers[m[2]].to_i
          proceed_to_next_instruction_after_execution = false
        end
      elsif m = /^jnz ([a-z]+) (-?\d+)$/.match(instruction)
        if @registers[m[1]] > 0
          instruction_index = instruction_index + m[2].to_i
          proceed_to_next_instruction_after_execution = false
        end
      elsif m = /^%nop$/.match(instruction)
        # Do nothing
      elsif m = /^%magic2 ([a-z]+) ([a-z]+)$/.match(instruction)
        @registers[m[1]] = @registers[m[1]] + @registers[m[2]]
        @registers[m[2]] = 0
      elsif m = /^%magic5 ([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+)/.match(instruction)
        destination_register = m[1]
        mult_part_one = m[2]
        mult_part_two = m[3]
        set_zero_register = m[4]
        @registers[destination_register] = @registers[destination_register] + (@registers[mult_part_one] * @registers[mult_part_two])
        @registers[mult_part_two] = 0
        @registers[set_zero_register] = 0
      elsif m = /^tgl ([a-z]+)/.match(instruction)
        instruction_toggle_offset = @registers[m[1]]
        if !instruction_toggle_offset.nil?
          instruction_index_to_toggle = instruction_index + instruction_toggle_offset
          if instruction_index_to_toggle < instructions.length
            instruction_to_toggle = instructions[instruction_index_to_toggle]
            new_instruction = toggle_instruction(instruction_to_toggle)
            instructions[instruction_index_to_toggle] = new_instruction

            optimized_instructions = optimize_instructions(instructions)
          end
        end
      else
        raise "Unknown instruction: #{instruction}!"
      end

      instruction_index = instruction_index + 1 if proceed_to_next_instruction_after_execution
    end

    @registers
  end

  def toggle_instruction(instruction)
    new_instruction = nil
    if m = /^inc (.*)/.match(instruction)
      new_instruction = "dec " + m[1]
    elsif m = /^(?:dec|tgl) (.*)/.match(instruction)
      new_instruction = "inc " + m[1]
    elsif m = /^jnz (.*)/.match(instruction)
      new_instruction = "cpy " + m[1]
    elsif m = /^cpy (.*)/.match(instruction)
      new_instruction = "jnz " + m[1]
    end
    return new_instruction
  end

  def optimize_instructions(instructions)
    instructions = instructions.dup
    slice_index = 0
    while slice_index < instructions.length
      a,b,c,d,e,f = instructions.slice(slice_index, 6)

      if (inc_match = /^inc ([a-z]+)$/.match(a)) && (dec_match = /^dec ([a-z]+)$/.match(b)) && (jnz_match = /^jnz ([a-z]+) -2$/.match(c))
        if dec_match[1] == jnz_match[1]
          instructions[slice_index] = "%nop"
          instructions[slice_index + 1] = "%nop"
          instructions[slice_index + 2] = "%magic2 " + inc_match[1] + " " + dec_match[1]
          slice_index = 0 # Start over
        else
          raise "Failed to handle -2 loop"
        end
      elsif (dec_match = /^dec ([a-z]+)$/.match(a)) && (inc_match = /^inc ([a-z]+)$/.match(b)) && (jnz_match = /^jnz ([a-z]+) -2$/.match(c))
        if dec_match[1] == jnz_match[1]
          instructions[slice_index] = "%nop"
          instructions[slice_index + 1] = "%nop"
          instructions[slice_index + 2] = "%magic2 " + inc_match[1] + " " + dec_match[1]
          slice_index = 0 # Start over
        else
          raise "Failed to handle -2 loop"
        end
      elsif (cpy_match = /^cpy ([a-z]+) ([a-z]+)$/.match(a)) && (/^%nop$/.match(b)) && (/^%nop$/.match(c)) && (magic_match = /^%magic2 ([a-z]+) ([a-z]+)/.match(d)) && (dec_match = /^dec ([a-z]+)/.match(e)) && (jnz_match = /^jnz ([a-z]+) -5/.match(f))
        if dec_match[1] == jnz_match[1] && cpy_match[2] == magic_match[2]
          destination_register = magic_match[1]
          mult_part_one = cpy_match[1]
          mult_part_two = dec_match[1]
          set_zero_register = magic_match[2]
          instructions[slice_index] = "%nop"
          instructions[slice_index + 1] = "%nop"
          instructions[slice_index + 2] = "%nop"
          instructions[slice_index + 3] = "%nop"
          instructions[slice_index + 4] = "%nop"
          instructions[slice_index + 5] = "%magic5 #{destination_register} #{mult_part_one} #{mult_part_two} #{set_zero_register}"
          slice_index = 0 # Start over
        else
          slice_index = slice_index + 1
        end
      else
        slice_index = slice_index + 1
      end
    end

    instructions
  end
end

# example_input = "cpy 2 a
# tgl a
# tgl a
# tgl a
# cpy 1 a
# dec a
# dec a
# "

# example_instructions = example_input.split("\n")

# pp AssembunnyExecutor.new.execute(example_instructions)



# multiply_input = "cpy b c
# inc a
# dec c
# jnz c -2
# dec d
# jnz d -5
# "
# multiply_instructions = multiply_input.split("\n")
# executor = AssembunnyExecutor.new
# executor.set_register("a", 100)
# executor.set_register("b", 4)
# executor.set_register("c", 1000)
# executor.set_register("d", 4)
# pp executor.execute(multiply_instructions)



challenge_input = "cpy a b
dec b
cpy a d
cpy 0 a
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
dec b
cpy b c
cpy c d
dec d
inc c
jnz d -2
tgl c
cpy -16 c
jnz 1 c
cpy 90 c
jnz 90 d
inc a
inc d
jnz d -2
inc c
jnz c -5
"

challenge_instructions = challenge_input.split("\n")
executor = AssembunnyExecutor.new
# executor.set_register("a", 7) # Part 1
executor.set_register("a", 12) # Part 2
result = executor.execute(challenge_instructions)
puts ""
puts "Registers after program has finished:"
pp result
