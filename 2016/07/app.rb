require_relative 'lib/challenge'
require 'pp'

def solve_part1
  # example_1 = "abba[mnop]qrst\nabcd[bddb]xyyx\naaaa[qwer]tyui\nioxxoj[asdfgh]zxcvbn"
  # puts example_1
  # input = example_1

  input = Challenge.new.input

  output = 0

  input.split("\n").each do |line|
    # puts "line:#{line}"
    i = 0
    chars = line.chars
    in_brackets = false
    abba_found_outside_bracket = false
    abba_found_inside_bracket = false
    loop do
      a,b,c,d = chars.slice(i, 4)
      break if d.nil? # end of string reached

      if "[" == a
        in_brackets = true
      elsif "]" == a
        in_brackets = false
      end

      # puts "   a:#{a} b:#{b} c:#{c} d:#{d} in_brackets:#{in_brackets}"

      if a != b && a == d && b == c
        # puts " + -> #{a}#{b}#{c}#{d}"
        if in_brackets
          abba_found_inside_bracket = true
        else
          abba_found_outside_bracket = true
        end
      end

      break if abba_found_inside_bracket

      i = i + 1
    end

    # puts "   #{line}: abba_found_inside_bracket:#{abba_found_inside_bracket} abba_found_outside_bracket:#{abba_found_outside_bracket}"

    if !abba_found_inside_bracket && abba_found_outside_bracket
      output = output + 1
    end
  end

  output
end

def solve_part2
  # example_1 = "aba[bab]xyz\nxyx[xyx]xyx\naaa[kek]eke\nzazbz[bzb]cdb"
  # puts example_1
  # input = example_1

  input = Challenge.new.input

  output = 0

  input.split("\n").each do |line|
    # puts "line:#{line}"
    i = 0
    chars = line.chars
    in_brackets = false
    aba_found_outside_bracket = false
    valid_babs = []
    bab_found = false
    loop do
      a,b,c = chars.slice(i, 3)
      break if c.nil? # end of string reached

      if "[" == a
        in_brackets = true
      elsif "]" == a
        in_brackets = false
      end

      # puts "   a:#{a} b:#{b} c:#{c} in_brackets:#{in_brackets}"

      unless ["[","]"].any? { |bracket| [a,b,c].any?(bracket) }
        if a != b && a == c
          unless in_brackets
            aba_found_outside_bracket = true
            valid_babs << [b,a,b]
            # puts " + -> #{a}#{b}#{c}"
          end
        end
      end

      i = i + 1
    end

    # puts " -- BEGIN valid babs --"
    # pp valid_babs
    # puts " -- END valid_babs --"
    bab_found = valid_babs.any? { |bab| line.scan(/\[[^\]]+\]/).any? { |bab_candidate| bab_candidate.include?(bab.join("")) } }

    # puts "   #{line}: aba_found_outside_bracket:#{aba_found_outside_bracket} bab_found:#{bab_found}"

    if aba_found_outside_bracket && bab_found
      output = output + 1
    end
  end

  output
end

puts solve_part1

puts solve_part2
