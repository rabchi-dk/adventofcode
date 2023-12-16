class SolverPart1
  def initialize
    @cached_gx = Hash.new
  end

  def solve(input)
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

class SolverPart2
  def initialize
    @line_solve_cache = Hash.new
  end

  def solve(input)
    total_sum = 0

    lines = input.split("\n")
    lines.each.with_index do |line, index|
      condition, checksum_ints = parse_line(line)
      total_sum = total_sum + solve_line(condition, checksum_ints)
      #puts "Finished line #{index+1}. total_sum: #{total_sum}."
    end

    total_sum
  end

  def parse_line(line)
    raise "Parser error" unless line.include?(" ")

    condition, checksum = line.split(" ")
    checksum_ints = checksum.split(",").collect { |s| s.to_i }

    condition = condition.gsub(/\.+/, ".")
    condition = ([condition] * 5).join("?")
    checksum_ints = checksum_ints * 5

    return [condition, checksum_ints]
  end

  def solve_line(condition, checksum_ints)
    start_state_descr = :scanning_outside_group
    start_index = 0
    return cached_solve_line_helper(start_state_descr, start_index, condition, checksum_ints)
  end

  def cached_solve_line_helper(state_descr, i, condition, checksum_ints)
    cache_key = (state_descr.to_s + ";" + condition.slice(i, condition.length) + ";" + checksum_ints.join(",")).freeze
    if cached_result = @line_solve_cache[cache_key]
      return cached_result
    end

    computed_result = solve_line_helper(state_descr, i, condition, checksum_ints)

    @line_solve_cache[cache_key] = computed_result

    return computed_result
  end

  def solve_line_helper(state_descr, i, condition, checksum_ints)
    # A lookahead: Checks if there's enough characters left to fill in the broken springs specified in the checksum
    # if :ended_group == state_descr && (condition.length - i - 1) < checksum_ints.sum
    #   return 0
    # end

    # A lookahead: If we're currently looking for ~checksum_ints.first~ number of broken springs we return early if we find a working spring in the next ~checksum_ints.first~ chars
    # if :scanning_group == state_descr && checksum_ints.length > 0 && condition.slice(i, checksum_ints.first).include?(".")
    #   return 0
    # end

    # Some helper variables
    current_char = condition[i]
    end_of_line_reached = current_char.nil?

    if end_of_line_reached
      if checksum_ints.empty? || (checksum_ints.length == 1 && checksum_ints.first == 0)
        # If the checksum says we're not looking for anymore broken springs then everything is good
        return 1
      else
        return 0
      end
    end

    if :scanning_outside_group == state_descr
      # This is the state we start in and return to when we are not scanning a group (or series) of broken springs or skipping over dots (working springs)
      if "#" == current_char
        # Start scanning a group (or series) of working springs
        return cached_solve_line_helper(:scanning_group, i, condition, checksum_ints)
      elsif "." == current_char
        # Start skipping over dots (working springs)
        return cached_solve_line_helper(:consumingdots, i, condition, checksum_ints)
      elsif "?" == current_char
        # There's two possible values for ?
        # We compute the results of both and sum them
        next_condition_with_dot = condition.dup
        next_condition_with_dot[i] = "."
        a = cached_solve_line_helper(:scanning_outside_group, i, next_condition_with_dot, checksum_ints)

        next_condition_with_hash = condition.dup
        next_condition_with_hash[i] = "#"
        b = cached_solve_line_helper(:scanning_outside_group, i, next_condition_with_hash, checksum_ints)

        return a + b
      end
    elsif :scanning_group == state_descr
      # We're scanning a group (or series) of broken springs.
      if "#" == current_char
        if checksum_ints.empty? || checksum_ints.first == 0
          # We have encountered a broken spring when we're not looking for one.
          return 0
        else
          # We have encountered a broken spring. Decrement the first number in our checksum.
          next_checksum_ints = checksum_ints.dup
          next_checksum_ints[0] = checksum_ints[0] - 1
          return cached_solve_line_helper(:scanning_group, i+1, condition, next_checksum_ints)
        end
      elsif "?" == current_char
        # There's two possible values for ?
        # We compute the results of both and sum them
        next_condition_with_dot = condition.dup
        next_condition_with_dot[i] = "."
        a = cached_solve_line_helper(:scanning_group, i, next_condition_with_dot, checksum_ints)

        next_condition_with_hash = condition.dup
        next_condition_with_hash[i] = "#"
        b = cached_solve_line_helper(:scanning_group, i, next_condition_with_hash, checksum_ints)

        return a + b
      elsif "." == current_char
        # We have encountered a working spring
        # Check if are expecting any more springs in this group (or series)
        if !checksum_ints.empty? && checksum_ints.first == 0
          return cached_solve_line_helper(:ended_group, i, condition, checksum_ints)
        else
          return 0
        end
      end
    elsif :ended_group == state_descr
      # We just finished successfully scanning a group (or series) of broken springs
      # This just drops the first checksum_int (which should be 0 since we only go to this state when it is 0)
      return cached_solve_line_helper(:consumingdots, i, condition, checksum_ints.drop(1))
    elsif :consumingdots == state_descr
      # Skipping dots (working springs)
      if "." == current_char
        return cached_solve_line_helper(:consumingdots, i+1, condition, checksum_ints)
      else
        return cached_solve_line_helper(:scanning_outside_group, i, condition, checksum_ints)
      end
    end
  end
end
