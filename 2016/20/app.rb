require 'pp'
require_relative 'lib/challenge'

input = Challenge.new.input

mins = []
maxes = []
ranges = []
input.split("\n").each do |line|
  if m= /^([0-9]+)-([0-9]+)$/.match(line)
    min = m[1].to_i
    max = m[2].to_i
    mins << min
    maxes << max
    ranges << (min..max)
  end
end

puts "-- Part 1: --"
pp [mins.sort.select { |min| min > 0 && ranges.none? { |r| r.include?(min-1) } }.first - 1,
    maxes.sort.select { |max| max < 4294967295 && ranges.none? { |r| r.include?(max+1) } }.first + 1].min

puts "-- Part 2: --"
def combine_ranges(input_ranges)
  combined_ranges = []
  loop do
    input_ranges = input_ranges.compact
    new_range = input_ranges.shift
    break if new_range.nil?

    input_ranges.each.with_index do |other_range, index|
      if new_range.include?(other_range.min) || other_range.include?(new_range.min)
        new_range = ([new_range.min, other_range.min].min)..([new_range.max, other_range.max].max)
        input_ranges[index] = nil
      end
    end

    combined_ranges << new_range
  end
  combined_ranges
end

# test_ranges = [
#   50..100,
#   100..200,
#   201..250,
#   0..49,
#   25..50,
#   300..400,
#   300..500,
#   256..500,
# ]

# combined_test_ranges = combine_ranges(test_ranges)

# puts "- combined test_ranges -"
# pp combined_test_ranges

combined_ranges = combine_ranges(ranges)
combined_ranges = combine_ranges(combined_ranges)
combined_ranges = combine_ranges(combined_ranges)
combined_ranges = combine_ranges(combined_ranges)
combined_ranges = combine_ranges(combined_ranges)

max_ip = 4294967295
num_of_possible_ips = (1 + max_ip)

pp num_of_possible_ips - combined_ranges.collect { |r| (r.max - r.min) + 1 }.inject(0) { |sum, num| sum = sum + num }
