class Solver
  def initialize
    @line_solve_cache = Hash.new
  end

  def solve_part2(input)
    total_sum = 0

    lines = input.split("\n")
    lines.each.with_index do |line, index|
      condition, checksum_ints = parse_line(line)
      total_sum = total_sum + cached_solve_line(condition, checksum_ints)
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

  def cached_solve_line(condition, checksum_ints)
    key = (condition + checksum_ints.join(",")).freeze
    if cached = @line_solve_cache[key]
      return cached
    end

    result = solve_line(condition, checksum_ints)

    @line_solve_cache[key] = result

    return result
  end

  def solve_line(condition, checksum_ints)
    # puts "condition:#{condition}"
    # print "checksum_ints:"
    # pp checksum_ints

    # Base case
    if checksum_ints.empty?
      # Not good
      if condition.include?("#")
        return 0
      end

      # Good
      return 1
    end

    # Another base case
    # Not good
    if condition.empty?
      return 0
    end

    # Branch on the two possibilities using recursion
    if condition.start_with?("?")
      next_condition_with_dot = "." + (condition.slice(1, condition.length) || "")
      next_condition_with_hash = "#" + (condition.slice(1, condition.length) || "")
      return cached_solve_line(next_condition_with_dot, checksum_ints) + cached_solve_line(next_condition_with_hash, checksum_ints)
    end

    # Trim dots
    if condition.start_with?(".")
      next_condition = condition.sub(/^[.]+/, "")
      return cached_solve_line(next_condition, checksum_ints)
    end

    if condition.start_with?("#")
      if checksum_ints.length == 0
        return 0
      end

      if condition.length < checksum_ints.first
        return 0
      end

      if condition.slice(0, checksum_ints.first).include?(".")
        return 0
      end

      if checksum_ints.length > 1
        if condition.length < checksum_ints.first+1 || "#" == condition[checksum_ints.first]
          return 0
        end

        next_condition = condition.slice(checksum_ints.first+1, condition.length)
        next_checksum_ints = checksum_ints.drop(1)
        return cached_solve_line(next_condition, next_checksum_ints)
      end

      # Last group
      next_condition = condition.slice(checksum_ints.first, condition.length)
      next_checksum_ints = checksum_ints.drop(1)
      return cached_solve_line(next_condition, next_checksum_ints)
    end
  end
end
