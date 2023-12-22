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
    paths_to = Hash.new
    goal_pos = [@max_row, @max_col]
    goal_reached_count = 0
    heuristic = lambda do |pos|
      (pos[0] - goal_pos[0]).abs + (pos[1] - goal_pos[1]).abs
    end

    path_cost_to = lambda do |current_direction, current_pos, raw_cost|
      if paths_to[current_pos].nil?
        raw_cost
      else
        okay_paths = paths_to[current_pos].collect { |path| path.last(3) }.reject { |path| path.collect { |dir, pos| dir }.all?(current_direction) }
        okay_paths.collect { |path| path.collect { |dir, pos| pos_cost(pos) }.sum }.min || raw_cost
      end
    end

    queue = start_neighbours.collect { |dir, pos, dir_count, cost| [dir, pos, dir_count, cost, [[dir, pos]], heuristic.call(pos)] }

    while !queue.empty?
      queue = queue.sort { |a,b| (path_cost_to.call(a[0], a[1], a[3]) + a[5]) <=> (path_cost_to.call(a[0], b[1], b[3]) + b[5]) }.reverse
      current_direction, current_pos, current_direction_count, current_path_cost, current_path, current_heuristic = queue.pop
      current_path_cost = path_cost_to.call(current_direction, current_pos, current_path_cost)
      pp queue.length
      pp [current_direction, current_pos, current_direction_count, current_path_cost, current_path, current_heuristic]

      visited_positions_count[current_pos] = visited_positions_count[current_pos] + 1
      if paths_to[current_pos].nil?
        paths_to[current_pos] = []
      end
      paths_to[current_pos] << current_path.dup

      if goal_pos == current_pos
        goal_reached_count = goal_reached_count + 1
        if goal_reached_count >= 4
          path_with_costs = current_path.collect { |dir, pos| [dir, pos, pos_cost(pos)] }
          pp path_with_costs.collect { |dir, pos, cost| cost }.sum
          pp paths_to[goal_pos].collect { |path| path.collect { |dir,pos| pos_cost(pos) }.sum }.min

          # print_path(current_path.collect { |dir, pos| pos })

          debugger if paths_to[goal_pos].collect { |path| path.collect { |dir,pos| pos_cost(pos) }.sum }.min <= 102
        end
      end

      to_add_to_queue = next_pos(current_pos, current_direction, current_direction_count, current_path_cost)
                          .reject { |dir, pos, dir_count, cost| visited_positions_count[pos] >= 1 }
                          .collect { |dir, pos, dir_count, cost| [dir, pos, dir_count, cost, (current_path + [[dir, pos]]), heuristic.call(pos)] }

      queue = (queue + to_add_to_queue)
    end
    debugger

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

  def print_path(path)
    path_string = @rows.collect.with_index do |row, ri|
      "#{sprintf("%3i", ri)}: " + row.collect.with_index do |cost, ci|
        if path.include?([ri, ci])
          " X#{cost} "
        else
          "  #{cost} "
        end
      end.join("")
    end.join("\n")
    puts "----" + ("----" * @rows[0].length)
    puts "    " + @rows[0].collect.with_index { |_,i| "  " + sprintf("%2i", i) }.join("")
    puts
    puts path_string
    puts "----" + ("----" * @rows[0].length)
  end
end

#input_challenge = File.read("input.txt")

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

# input_example = "24134
# 32154
# 32552
# 34465
# "


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
