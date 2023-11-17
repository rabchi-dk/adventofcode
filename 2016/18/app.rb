class TiledFloor
  TRAP_GENERATOR_REGEX = Regexp.compile("^(?:t[ts]s|s[st]t)$")

  def generate(input, num_of_lines)
    first_line = convert_to_our_own_representation(input)

    result = [first_line]

    while result.count < num_of_lines
      previous_line = result.last
      current_line = ""

      (["s"] + previous_line.chars + ["s"]).each_cons(3) do |triple|
        if TRAP_GENERATOR_REGEX.match(triple.join(""))
          current_line << "t"
        else
          current_line << "s"
        end
      end

      result << current_line
    end

    convert_to_aoc_representation(result.join("\n"))
  end

  def convert_to_our_own_representation(input)
    input.tr(".^", "st")
  end

  def convert_to_aoc_representation(input)
    input.tr("st", ".^")
  end
end

# Example
# puts TiledFloor.new.generate(".^^.^.^^^^", 10).chars.select { |c| c == "." }.count

input = ".^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^."

puts "-- Part 1: --"
puts TiledFloor.new.generate(input, 40).chars.select { |c| c == "." }.count

puts "-- Part 2: --"
puts TiledFloor.new.generate(input, 400000).chars.select { |c| c == "." }.count
