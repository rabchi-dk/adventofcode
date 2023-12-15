require 'debug'

class Solver
  def initialize
    @cached_gx = Hash.new
  end

  def solve_part2(input)
    total_sum = 0
    lines = input.split("\n")
    lines.each.with_index do |line, index|
      #puts "#{index}: #{line}"

      raise "Parser error" unless line.include?(" ")

      condition, checksum = line.split(" ")
      checksum_ints = checksum.split(",").collect { |s| s.to_i }

      condition = condition.gsub(/\.+/, ".")
      condition = ([condition] * 5).join("?")
      checksum_ints = checksum_ints * 5
      puts "#{index}: UNFOLDED #{condition} (length:#{condition.length}, num dots: #{condition.count(".")}) #{checksum_ints.join(",")} (sum: #{checksum_ints.sum}, required dots:#{checksum_ints.length-1})"

      stupid_result = stupid_f(condition, checksum_ints)
      puts " -- END OF STUPID_F --"
      pp stupid_result
    end

    total_sum
  end

  def stupid_f(condition, checksum_ints)
    condition = (condition || "").gsub(/^\.+|\.+$/, "")
    puts "condition:  #{condition}"
    pp checksum_ints
    puts "---"

    # Base case
    if checksum_ints.empty?
      return 1
    end

    # Only one option possible
    if condition.length == checksum_ints.sum + checksum_ints.length - 1
      puts "  MAGIC HAPPENS AND ONLY ONE OPTION IS LEFT!"
      return 1
    end

    number = checksum_ints.first
    last_number = checksum_ints.last

    if number == 1 && /^[?]#[?.]/.match(condition)
      return 1 * stupid_f(condition[3..-1], checksum_ints[1..-1])
    elsif m = /^#/.match(condition)
      return 1 * stupid_f(condition[(number+1)..-1], checksum_ints[1..-1])
    end

    if Regexp.compile('#$').match(condition)
      until_idx = (-1 * last_number) - 1
      return 1 * stupid_f(condition[0..until_idx], checksum_ints[0..-2])
    elsif last_number == 1 && /[?.]#[?]$/.match(condition)
      return 1 * stupid_f(condition[0..-4], checksum_ints[0..-2])
    end

    continous_broken_lengths = condition.scan(/#+/).collect { |b| b.length }
    checksum_ints.uniq.each do |cksum_val|
      if checksum_ints.count(cksum_val) == continous_broken_lengths.count(cksum_val)
        found_condition = "#" * cksum_val
        cn, cn_tail = condition.split(found_condition, 2)
        split_by_idx = checksum_ints.index(cksum_val)
        ck, ck_tail = [checksum_ints.take(split_by_idx+1), checksum_ints.drop(split_by_idx+1)]
        return stupid_f(cn + found_condition, ck) * stupid_f(cn_tail, ck_tail)
      end
    end

    return valid_conditions = find_valid_conditions(condition, checksum_ints).length
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

input = File.read("input_example.txt")

solver = Solver.new
puts solver.solve_part2(input)

