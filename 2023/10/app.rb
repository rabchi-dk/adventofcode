require 'debug'

class Solver
  LOOKING_FOR = {
    ["S", :up].freeze    => ["S", "|", "F", "7"].freeze,
    ["S", :right].freeze => ["S", "-", "J", "7"].freeze,
    ["S", :down].freeze  => ["S", "J", "|", "L"].freeze,
    ["S", :left].freeze  => ["S", "-", "F", "L"].freeze,

    ["J", :up].freeze    => ["S", "|", "F", "7"].freeze,
    ["J", :right].freeze => ["S"].freeze,
    ["J", :down].freeze  => ["S"].freeze,
    ["J", :left].freeze  => ["S", "-", "F", "L"].freeze,

    ["|", :up].freeze    => ["S", "|", "F", "7"].freeze,
    ["|", :right].freeze => ["S"].freeze,
    ["|", :down].freeze  => ["S", "|", "J", "L"].freeze,
    ["|", :left].freeze  => ["S"].freeze,

    ["L", :up].freeze    => ["S", "|", "F", "7"].freeze,
    ["L", :right].freeze => ["S", "-", "J", "7"].freeze,
    ["L", :down].freeze  => ["S"].freeze,
    ["L", :left].freeze  => ["S"].freeze,

    ["F", :up].freeze    => ["S"].freeze,
    ["F", :right].freeze => ["S", "-", "J", "7"].freeze,
    ["F", :down].freeze  => ["S", "|", "J", "L"].freeze,
    ["F", :left].freeze  => ["S"].freeze,

    ["7", :up].freeze    => ["S"].freeze,
    ["7", :right].freeze => ["S"].freeze,
    ["7", :down].freeze  => ["S", "|", "J", "L"].freeze,
    ["7", :left].freeze  => ["S", "-", "L", "F"].freeze,

    ["-", :up].freeze    => ["S"].freeze,
    ["-", :right].freeze => ["S", "-", "J", "7"].freeze,
    ["-", :down].freeze  => ["S"].freeze,
    ["-", :left].freeze  => ["S", "-", "L", "F"].freeze,
  }

  MOVEMENT_VECTORS = [[:up, [-1, 0].freeze].freeze, [:right, [0, 1].freeze].freeze, [:down, [1, 0].freeze].freeze, [:left, [0, -1].freeze].freeze].freeze

  def initialize(input)
    @input = input
    @lines = input.split("\n")
    @max_row = @lines.length-1
    @max_col = @lines[0].length-1
  end

  def solve
    start_pos = find_start_pos
    #pp "START: #{get_char(start_pos)}"

    start_neighbours = neighbours(start_pos).collect { |dir, pos| pos }
    raise "Start must have two neighbours" unless start_neighbours.length == 2

    queue = [start_neighbours.first]
    visited_positions = [start_pos]
    goal_pos = start_neighbours.last

    while !queue.empty?
      #raise "Failure: We traversed more positions than the input contains." if visited_positions.length > @input.length

      current_pos = queue.pop

      if goal_pos == current_pos
        return (visited_positions.length + 1) / 2
      else
        visited_positions << current_pos
      end

      # pp "current_pos: #{current_pos}"
      # pp "goal_pos: #{goal_pos}"
      # pp "visited_positions: #{visited_positions}"

      queue = queue + neighbours(current_pos).collect { |dir, pos| pos }.reject { |pos| visited_positions.last(2).include?(pos) }
    end
  end

  def find_start_pos
    start_positions = @lines.collect.with_index do |line, row|
      line.chars.collect.with_index do |char, col|
        [char, row, col]
      end
    end.flatten(1).select { |char, row, col| "S" == char }

    raise "Only one start position is allowed!" unless start_positions.length == 1

    start_positions.collect { |char, row, col| [row, col] }.first
  end

  def get_char(pos)
    row, col = pos
    @lines[row][col]
  end

  def possible_neighbours(pos)
    row, col = pos
    MOVEMENT_VECTORS.collect { |dir, (drow, dcol)|
      nrow = row+drow
      ncol = col+dcol
      [dir, [nrow, ncol].freeze] if nrow >= 0 && nrow <= @max_row && ncol >= 0 && ncol <= @max_col
    }.compact
  end

  def neighbours(pos)
    current_char = get_char(pos)
    possible_neighbours(pos).select do |current_dir, neighbour_pos|
      neighbour_char = get_char(neighbour_pos)
      LOOKING_FOR[[current_char, current_dir].freeze].include?(neighbour_char)
    end
  end
end

input_example = "..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"

input_challenge = File.read("input.txt")



puts "Example:"
solver = Solver.new(input_example)
puts solver.solve

puts "Part 1:"
solver = Solver.new(input_challenge)
puts solver.solve
