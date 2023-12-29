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
    queue = Hash.new
    queue = add_to_queue(queue, next_pos(start_pos, start_direction, 1, 0).collect { |dir, pos, dir_count, cost| [dir, pos, dir_count, cost, ([[dir, pos]])] })

    visited_positions_count = Hash.new(0)
    goal_pos = [@max_row, @max_col]
    goal_reached_count = 0

    while !queue.empty?
      current_direction, current_pos, current_direction_count, current_path_cost, current_path = pop_from_queue(queue)
      puts "#{queue.values.length}, #{visited_positions_count.keys.length}, #{current_path_cost}"

      if visited_positions_count[[current_direction, current_direction_count, current_pos]] >= 1
        next
      else
        visited_positions_count[[current_direction, current_direction_count, current_pos]] += 1
      end

      if goal_pos == current_pos
        goal_reached_count = goal_reached_count + 1
        if goal_reached_count >= 1
          path_with_costs = current_path.collect { |dir, pos| [dir, pos, pos_cost(pos)] }

          # print_path(current_path.collect { |dir, pos| pos })

          return path_with_costs.collect { |dir, pos, cost| cost }.sum
        end
      end

      to_add_to_queue = next_pos(current_pos, current_direction, current_direction_count, current_path_cost)
                          #.reject { |dir, pos, dir_count, cost, path| current_path.collect { |dir, pos| pos }.include?(pos) }
                          .collect { |dir, pos, dir_count, cost| [dir, pos, dir_count, cost, (current_path + [[dir, pos]])] }

      queue = add_to_queue(queue, to_add_to_queue)
    end

    return nil
  end

  def add_to_queue(queue, to_add_to_queue)
    to_add_hash = to_add_to_queue.group_by { |dir, pos, dir_count, cost, path| cost }.to_h

    to_add_hash.each do |key, values|
      queue[key] = [] if queue[key].nil?
      queue[key] = queue[key] + values
    end

    return queue
  end

  def pop_from_queue(queue)
    a_key = queue.keys.min

    if queue[a_key].empty?
      queue.delete(a_key)
      return pop_from_queue(queue)
    end

    return queue[a_key].pop
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
    }.compact
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
