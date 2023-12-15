require 'debug'

class Solver
  def initialize
    @cached_gx = Hash.new
  end

  def solve_part1(input)
    total_sum = 0
    lines = input.split("\n")
    lines.each.with_index do |line, index|
      puts "#{index}: #{line}"

      raise "Parser error" unless line.include?(" ")

      condition, checksum = line.split(" ")
      checksum_ints = checksum.split(",").collect { |s| s.to_i }

      valid_conditions = find_valid_conditions(condition, checksum_ints)

      puts "num of valid_conditions: #{valid_conditions.length}"

      total_sum = total_sum + valid_conditions.length
    end

    return total_sum
  end

  def find_valid_conditions(condition, checksum_ints)
    total_damaged = checksum_ints.sum
    unknown_count = condition.chars.count { |c| "?" == c }
    known_damaged_count = condition.chars.count { |c| "#" == c }

    unknown_damaged_count = total_damaged - known_damaged_count
    unknown_undamaged_count = unknown_count - unknown_damaged_count

    #raise "error" if unknown_damaged_count + unknown_undamaged_count != unknown_count

    guesses = gx(unknown_damaged_count, unknown_undamaged_count)
    valid_conditions = guesses
                         .collect { |guess| insert_guess_into_condition(condition, guess) }
                         .select { |possible_condition| is_valid_condition?(possible_condition, checksum_ints) }

    # valid_conditions.each do |vc|
    #   puts "  #{vc}"
    # end
    valid_conditions
  end

  def insert_guess_into_condition(condition, guess)
    result = ""
    repl_count = 0
    condition.chars.each do |c|
      if "?" == c
        result << guess[repl_count]
        repl_count = repl_count + 1
      else
        result << c
      end
    end

    #puts "guess: #{result}"
    return result
  end

  def is_valid_condition?(possible_condition, checksum_ints)
    checksum_ints == possible_condition.split(/\.+/).reject { |a| a.empty? }.collect { |a| a.length }
  end

  def gx(d, u)
    if cached = @cached_gx[[d,u].freeze]
      return cached
    end

    a = 0.step(d+u-1).to_a.combination(d).to_a

    result = a.collect do |i|
      b = "." * (d+u)
      i.each do |ii|
        b[ii] = "#"
      end
      b
    end

    @cached_gx[[d,u].freeze] = result
    result
  end
end

input = File.read("input_challenge.txt")

solver = Solver.new
puts solver.solve_part1(input)

