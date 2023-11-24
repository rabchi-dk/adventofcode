require_relative 'lib/challenge'
require 'debug'

class DevNode
  def initialize(id, size, used, avail)
    @id = id
    @size = size
    @used = used
    @avail = avail
  end
  attr_reader :id, :size, :used, :avail

  def eql?(other)
    id == other.id
  end

  def hash
    @id.hash
  end

  def <=>(other)
    @id <=> other.id
  end

  def empty?
    0 == used
  end

  def data_fits_in_node?(other_node)
    other_node.avail >= used
  end
end

class DevNodeParser
  def parse(input)
    lines = Challenge.new.input.split("\n")[2..-1] # Skip first two lines (command and headers)

    nodes = Hash.new(0)

    lines.each do |line|
      if m = /^\/dev.grid.node.x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/.match(line)
        x = m[1].to_i
        y = m[2].to_i
        size = m[3].to_i
        used = m[4].to_i
        avail = m[5].to_i
        id = "#{x},#{y}"
        nodes[id] = DevNode.new(id, size, used, avail)
      else
        raise "Parser error! line: #{line}"
      end
    end

    nodes
  end
end

class SolverPart1
  def solve(nodes)
    all_possible_pairs = nodes.values.permutation(2)
    all_possible_pairs
      .select { |a,b| !a.empty? && a.data_fits_in_node?(b) }
      #.collect { |a,b| "#{a.id}: used is #{a.used} --> #{b.id}: avail is #{b.avail}" }
      .count
  end
end

input = Challenge.new.input
nodes = DevNodeParser.new.parse(input)

puts "-- Part 1: --"
puts SolverPart1.new.solve(nodes)
