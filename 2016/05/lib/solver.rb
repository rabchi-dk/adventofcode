require 'digest'
class Solver
  InterestingHashStruct = Struct.new(:index, :hash)

  def solve_part1(input)
    current_index = 0
    password = ""
    loop do
      interesting_hash = find_interesting_hash(input, current_index)

      password << interesting_hash.hash[5]

      if password.length == 8
        break
      else
        current_index = interesting_hash.index + 1
      end
    end

    password
  end

  def solve_part2(input)
    current_index = 0
    password = [nil] * 8

    loop do
      interesting_hash = find_interesting_hash(input, current_index)

      position = interesting_hash.hash[5].to_i(16)
      if position <= 7 && password[position].nil?
        password[position] = interesting_hash.hash[6]
        #puts "password: " + password.collect { |c| c.nil? ? "*" : c }.join("")
      end

      if password.any?(nil)
        current_index = interesting_hash.index + 1
      else
        break
      end
    end

    password.join("")
  end

  def find_interesting_hash(string, start_index)
    index = start_index || 0
    hash = ""

    loop do
      hash = Digest::MD5.hexdigest(string + index.to_s)
      if hash.start_with?("00000")
        break
      else
        index = index + 1
      end
    end

    InterestingHashStruct.new(index, hash)
  end
end
