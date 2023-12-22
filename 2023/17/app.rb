require 'debug'

class Solver
  MOVEMENT_VECTORS = [[:up, [-1, 0]], [:right, [0, 1]], [:down, [1, 0]], [:left, [0, -1]]].collect { |x| x.freeze }

  def initialize(input)
    @input = input
    @rows = @input.split("\n").collect.with_index do |line, index|
      line.chars.collect { |c| c.to_i }
    end
    @max_row = @rows.length-1
    @max_col = @rows[0].length-1
  end

  def solve
    start_pos = [0, 0]
    start_direction = nil
    start_neighbours = next_pos(start_pos, start_direction, 1)

    queue = start_neighbours
    visited_positions = [[:right, start_pos]]
    goal_pos = [@max_row, @max_col]

    while !queue.empty?
      current_direction, current_pos, current_direction_count = queue.pop
      pp [current_direction, current_pos, current_direction_count]

      if goal_pos == current_pos
        raise "TODO: Implement this!"
      else
        visited_positions << current_pos
      end

      to_add_to_queue = next_pos(current_pos, current_direction, current_direction_count)
                          .reject { |dir, pos, dir_count| visited_positions.include?(pos) }
      queue = queue + to_add_to_queue
    end

    return nil
  end

  def next_pos(pos, direction, direction_count)
    row, col = pos

    interesting_directions = [:up, :down, :left, :right]
    if !direction.nil?
      interesting_directions = if [:up, :down].include?(direction) then [:left, :right] else [:up, :down] end
      if direction_count < 3
        interesting_directions << direction
      end
    end

    MOVEMENT_VECTORS.select { |dir, _| interesting_directions.include?(dir) }.collect { |dir, (drow, dcol)|
      nrow = row+drow
      ncol = col+dcol
      if nrow >= 0 && nrow <= @max_row && ncol >= 0 && ncol <= @max_col
        [
          dir,
          [nrow, ncol].freeze,
          if dir == direction
            direction_count + 1
          else
            1
          end
        ]
      else
        nil
      end
    }.compact
  end
end

input_challenge = File.read("input.txt")

input_example = "2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
"

solver = Solver.new(input_example)
pp solver.solve
