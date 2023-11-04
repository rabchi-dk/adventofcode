require_relative 'lib/challenge'
require 'pp'

# example = "eedadn
# drvtee
# eandsr
# raavrd
# atevrs
# tsrnev
# sdttsa
# rasrtv
# nssdts
# ntnada
# svetve
# tesnvt
# vntsnd
# vrdear
# dvrsen
# enarar
# "

def solve(part)
  input = Challenge.new.input

  counts = (1..(input.index("\n"))).collect { Hash.new(0) }

  input.split("\n").each do |line|
    line.chars.each_with_index do |char, i|
      counts[i][char] = counts[i][char] + 1
    end
  end

  map_part_to_method = {
    :part1 => :last, # Most common
    :part2 => :first # Least common
  }

  counts.collect { |hash| hash.to_a.sort_by { |key,value| value }.send(map_part_to_method[part]).first }.join("")
end

puts solve(:part1)

puts solve(:part2)
