require_relative 'lib/challenge'
require 'debug'

class DevNode
  def initialize(id, size, used, has_goal_data = nil)
    @id = id
    @size = size
    @used = used
    @has_goal_data = has_goal_data || false
  end
  attr_reader :id, :size, :used

  def has_goal_data?
    @has_goal_data
  end

  def has_goal_data!
    @has_goal_data = true
  end

  def no_goal_data!
    @has_goal_data = false
  end

  def avail
    @size - @used
  end

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

  def coords
    @id.split(",").collect { |n| n.to_i }
  end

  def move_data_to(other_node)
    other_node.add_data(@used)
    @used = 0
    if has_goal_data?
      other_node.has_goal_data!
      no_goal_data!
    end
  end

  def add_data(amount)
    @used = @used + amount
  end
end

class DevNodeParser
  def parse(input)
    lines = input.split("\n")[2..-1] # Skip first two lines (command and headers)

    nodes = Hash.new(0)

    lines.each do |line|
      if m = /^\/dev.grid.node.x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T/.match(line)
        x = m[1].to_i
        y = m[2].to_i
        size = m[3].to_i
        used = m[4].to_i
        #avail = m[5].to_i
        id = "#{x},#{y}"
        nodes[id] = DevNode.new(id, size, used)
      else
        raise "Parser error! line: #{line}"
      end
    end

    goal_data_node = nodes.values.select { |n| 0 == n.coords[1] }.max { |n| n.coords[0] }
    goal_data_node.has_goal_data!

    coords = nodes.values.collect { |node| node.coords }
    max_x = coords.collect { |x,y| x }.max
    max_y = coords.collect { |x,y| y }.max
    grid = DevNodeGrid.new(nodes, max_x, max_y)
    grid.node_with_goal_data = goal_data_node

    grid
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

class MoveDataAction
  def initialize(from, to)
    @from = from
    @to = to
  end
  attr_reader :to, :from
end

class DevNodeGrid
  def initialize(nodes, max_x, max_y)
    @nodes = nodes
    @max_x = max_x
    @max_y = max_y
    @node_with_goal_data = nil
  end
  attr_reader :max_x, :max_y
  attr_accessor :node_with_goal_data

  def values
    @nodes.values
  end

  def node_by_id(id)
    @nodes[id]
  end

  def possible_moves
    moves = []
    @nodes.values.each do |node|
      neighbouring_nodes(node).each do |neighbouring_node|
        if node.data_fits_in_node?(neighbouring_node)
          moves << MoveDataAction.new(node, neighbouring_node)
        end
      end
    end
    moves
  end

  def neighbouring_nodes(node)
    neighbouring_coords(node.coords).collect do |coord|
      @nodes["#{coord[0]},#{coord[1]}"]
    end
  end

  def neighbouring_coords(coords)
    x,y = coords
    vectors = [
      [-1,  0], # Up
      [ 1,  0], # Down
      [ 0,  1], # Right
      [ 0, -1], # Left
    ]
    vectors.collect do |dx,dy|
      if x + dx >= 0 && x + dx <= @max_x && y + dy >= 0 && y + dy <= @max_y
        [x + dx, y + dy]
      else
        nil
      end
    end.compact
  end

  def as_comparable
    @node_with_goal_data.id + "G;" + @nodes.values.sort_by { |node| node.coords }.collect { |node| (node.used == 0 ? "_" : ".") }.join(";")
  end

  def is_goal_state?
    @nodes["0,0"].has_goal_data?
  end

  def do_move(move)
    new_from = move.from.dup
    new_to = move.to.dup
    new_from.move_data_to(new_to)

    new_nodes = @nodes.dup
    new_nodes[new_from.id] = new_from
    new_nodes[new_to.id] = new_to

    result = DevNodeGrid.new(new_nodes, max_x, max_y)
    if new_from.has_goal_data?
      result.node_with_goal_data = new_from
    elsif new_to.has_goal_data?
      result.node_with_goal_data = new_to
    else
      result.node_with_goal_data = node_with_goal_data.dup
    end
    result
  end

  def to_s
    0.step(@max_y).collect do |y|
      sprintf("%2i:", y) + 0.step(@max_x).collect do |x|
        node = @nodes["#{x},#{y}"]
        #(node.used == 0 ? "X" : " ") + sprintf("%3i", node.used) + "/" + sprintf("%3i", node.size) + (node.has_goal_data? ? "G" : " ")
        (node.used == 0 ? "X" : ".") + (node.has_goal_data? ? "G" : " ")
      end.join("  ")
    end.join("\n")
  end

  def score
    distance = lambda do |a,b|
      (a[0] - b[0]).abs + (a[1] - b[1]).abs
    end

    empty_node = @nodes.values.select { |node| 0 == node.used }.first

    # HARDCODED DIRTY TRICK
    # There's a wall of immovable >500T nodes at y=2
    # This code divides the solution into two parts:
    # - First getting past the wall (through node [1,2]).
    # - Then getting the goal data to where we can read it.

    distance_part1 = nil
    if empty_node.coords[1] <= 2
      distance_part1 = distance.call(empty_node.coords, node_with_goal_data.coords)
    else
      distance_part1 = 800 + distance.call(empty_node.coords, [1,2])
    end
    distance_part2 = distance.call([0,0], node_with_goal_data.coords)

    distance_part1 + distance_part2
  end
end

class SolverPart2
  def solve(grid)
    global_seen = []
    queue = [[grid, [grid]]]

    itr = 0
    while !queue.empty?
      queue = queue.sort_by { |grid, path| path.length + grid.score }
      current_grid, current_path = queue.shift

      itr = itr + 1
      if itr % 100 == 0
        puts "itr: #{itr}, current score: #{current_grid.score}, current_path.length:#{current_path.length}, queue.length:#{queue.length}"
        # puts "- BEGIN PATH -"
        # current_path.each do |g|
        #   puts g.to_s
        #   puts "---"
        # end
        # puts "- END OF PATH -"
      end

      if current_grid.is_goal_state?
        puts "GOAL STATE REACHED!"
        return current_path
      end

      current_grid.possible_moves.each do |a_move|
        next_grid = current_grid.do_move(a_move)
        queue << [next_grid, current_path + [next_grid]] unless global_seen.include?(next_grid.as_comparable)
        global_seen << next_grid.as_comparable
      end
    end

    return nil
  end
end

input = Challenge.new.input
nodes = DevNodeParser.new.parse(input)

puts "-- Part 1: --"
puts SolverPart1.new.solve(nodes)

puts "-- Part 2: --"
challenge_input = Challenge.new.input
challenge_nodes = DevNodeParser.new.parse(challenge_input)

solver = SolverPart2.new
result_path = solver.solve(challenge_nodes)

if result_path.nil?
  puts "Failed!"
else
  puts "- BEGIN PATH -"
  result_path.each do |g|
    puts g.to_s
    puts "---"
  end
  puts "- END OF PATH -"
  puts "Number of stepds: #{result_path.length - 1}" # Subtract initial state
end





# Part 2 example
# example_input = "df -h
# Filesystem            Size  Used  Avail  Use%
# /dev/grid/node-x0-y0   10T    8T     2T   80%
# /dev/grid/node-x0-y1   11T    6T     5T   54%
# /dev/grid/node-x0-y2   32T   28T     4T   87%
# /dev/grid/node-x1-y0    9T    7T     2T   77%
# /dev/grid/node-x1-y1    8T    0T     8T    0%
# /dev/grid/node-x1-y2   11T    7T     4T   63%
# /dev/grid/node-x2-y0   10T    6T     4T   60%
# /dev/grid/node-x2-y1    9T    8T     1T   88%
# /dev/grid/node-x2-y2    9T    6T     3T   66%
# "

# example_nodes = DevNodeParser.new.parse(example_input)

# solver = SolverPart2.new
# result_path = solver.solve(example_nodes)
