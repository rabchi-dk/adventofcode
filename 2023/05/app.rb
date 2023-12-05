require_relative 'lib/challenge'
require 'debug'

class GardenMapper
  def initialize(dest_range_start, source_range_start, range_length)
    @source_start = source_range_start
    @source_end = source_range_start + range_length - 1
    @dest_start = dest_range_start
    @dest_end = dest_range_start + range_length - 1
    @range_length = range_length
  end

  def map(num, maptype = nil)
    rel = num - @source_start
    if 0 <= rel && rel < @range_length
      return true, @dest_start + rel
    else
      return false, num
    end
  end
end

class Solve
  MAP_PATH = ["seed", "soil", "fertilizer", "water", "light", "temperature", "humidity", "location"]

  def solve(input)
    counts = Hash.new(0)
    mappers = Hash.new { |k,v| Array.new }
    my_seeds = nil
    key = nil

    lines = input.split("\n")

    lines.each.with_index do |line, index|
      puts "#{index}: #{line}"
      if m = /^seeds:(.*)/.match(line)
        my_seeds = m[1].scan(/\d+/).collect { |n| n.to_i }
      elsif m = /^([a-z]+)-to-([a-z]+) map:/.match(line)
        from = m[1]
        to = m[2]

        key = from
        pp "new key: #{key}"
      elsif m = /^(\d+) (\d+) (\d+)/.match(line)
        dest_range_start = m[1].to_i
        source_range_start = m[2].to_i
        range_length = m[3].to_i
        mappers[key] = mappers[key] + [GardenMapper.new(dest_range_start, source_range_start, range_length)]
        # debugger if key == "seed"
      elsif /^$/.match(line)
        # Do nothing
      else
        raise "parser error"
      end
    end

    raise "No seeds" if my_seeds.empty?

    locations = []
    my_seeds.each do |seed|
      puts "Handling seed #{seed}"
      mapped_seed = seed
      MAP_PATH.each do |p|
        puts "  doing #{p} mapping"
        mappers[p].each do |mapper|
          puts "  trying to do #{p} map from #{mapped_seed}"
          matched, mapped_seed = mapper.map(mapped_seed, p)
          break if matched
        end
      end
      puts "  end of mapping: #{mapped_seed}"
      locations << mapped_seed
    end
    locations.min
  end
end

solver = Solve.new

input_challenge = Challenge.new.input

input_example = "seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"

res = solver.solve(input_challenge)
puts res
