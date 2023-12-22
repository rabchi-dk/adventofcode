require 'debug'

class Solver
  MOVEMENT_VECTORS = [[:up, [-1, 0]], [:right, [0, 1]], [:down, [1, 0]], [:left, [0, -1]]].collect { |x| x[1].freeze; x.freeze }

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
    start_neighbours = next_pos(start_pos, start_direction, 1, 0)

    visited_positions = []
    visited_positions_count = Hash.new(0)
    visited_positions_count[start_pos] = 1
    path_cost_to = Hash.new
    goal_pos = [@max_row, @max_col]
    goal_reached_count = 0
    heuristic = lambda do |pos|
      (pos[0] - goal_pos[0]).abs + (pos[1] - goal_pos[1]).abs
    end

    queue = start_neighbours.collect { |dir, pos, dir_count, cost| [dir, pos, dir_count, cost, [pos], heuristic.call(pos)] }

    while !queue.empty?
      queue = queue.sort { |a,b| ((path_cost_to[a[1]] || a[3]) + a[5]) <=> ((path_cost_to[b[1]] || b[3]) + b[5]) }.reverse
      current_direction, current_pos, current_direction_count, current_path_cost, current_path, current_heuristic = queue.pop
      pp [current_direction, current_pos, current_direction_count, current_path_cost, current_path, current_heuristic]

      visited_positions_count[current_pos] = visited_positions_count[current_pos] + 1
      if path_cost_to[current_pos].nil?
        path_cost_to[current_pos] = current_path_cost
      end
      # if path_cost_to[current_pos] > current_path_cost
      #   path_cost_to[current_pos] = current_path_cost
      # else
      #   current_path_cost = path_cost_to[current_pos]
      # end

      if goal_pos == current_pos
        goal_reached_count = goal_reached_count + 1
        if goal_reached_count >= 1
          pp path_cost_to[current_pos]
          path_with_costs = current_path.collect { |pos| [pos, pos_cost(pos)] }
          pp path_with_costs.collect { |pos, cost| cost }.sum
          debugger
          raise "TODO: Implement this!"
        end
      end

      to_add_to_queue = next_pos(current_pos, current_direction, current_direction_count, current_path_cost)
                          .reject { |dir, pos, dir_count, cost| visited_positions_count[pos] >= 1 }
                          .collect { |dir, pos, dir_count, cost| [dir, pos, dir_count, cost, (current_path + [pos]), heuristic.call(pos)] }

      queue = (queue + to_add_to_queue).uniq { |dir, pos, dir_count, cost, path, heuristic| [pos, cost+heuristic] }
    end

    return nil
  end

  def next_pos(pos, direction, direction_count, current_cost)
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
        npos = [nrow, ncol].freeze
        [
          dir,
          npos,
          if dir == direction then direction_count + 1 else 1 end,
          current_cost + pos_cost(npos),
        ]
      else
        nil
      end
    }.compact.shuffle
  end

  def pos_cost(pos)
    @rows[pos[0]][pos[1]]
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

input_solution = "2>>34^>>>1323
32v>>>35v5623
32552456v>>54
3446585845v52
4546657867v>6
14385987984v4
44578769877v6
36378779796v>
465496798688v
456467998645v
12246868655<v
25465488877v5
43226746555v>
"

# pp input_solution.chars.count { |c| [">","<","v", "^"].include?(c) }
# exit

solver = Solver.new(input_example)
pp solver.solve
