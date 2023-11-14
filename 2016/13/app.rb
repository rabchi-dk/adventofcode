class SolutionCandidate
  def initialize(location, previous_solution_candidate, step_count = nil)
    @location = location
    @previous_solution_candidate = previous_solution_candidate
    @step_count = step_count
  end
  attr_reader :location, :previous_solution_candidate, :step_count

  def locations
    solution_locations = []
    current_iteration = self
    while !current_iteration.nil?
      solution_locations << current_iteration.location
      current_iteration = current_iteration.previous_solution_candidate
    end
    solution_locations.reverse
  end
end

class CubicleMaze
  PUZZLE_INPUT = 1352
  GOAL_LOCATION = "31,39"

  def is_open_space?(location)
    x, y = location.split(",").collect { |n| n.to_i }
    calc_result = (x*x) + (3*x) + (2*x*y) + y + (y*y) + PUZZLE_INPUT
    binary_result = calc_result.to_s(2)
    binary_result.chars.count { |c| c == "1" }.even?
  end

  def find_path
    start_location = "1,1"
    seen_locations = [start_location]
    queue = []

    queue << SolutionCandidate.new(start_location, nil)

    until queue.empty?
      current_solution_candidate = queue.shift
      current_location = current_solution_candidate.location

      if is_goal_state?(current_location)
        return current_solution_candidate.locations
      end

      neighbour_locations(current_location).each do |next_location|
        if seen_locations.include?(next_location)
          # Do nothing
        else
          seen_locations << next_location
          queue << SolutionCandidate.new(next_location, current_solution_candidate)
        end
      end
    end

    return nil
  end

  def find_reachable_locations
    start_location = "1,1"
    seen_locations = [start_location]
    queue = []

    queue << SolutionCandidate.new(start_location, nil, 0)

    until queue.empty?
      current_solution_candidate = queue.shift
      current_location = current_solution_candidate.location

      unless current_solution_candidate.step_count >= 50
        neighbour_locations(current_location).each do |next_location|
          if seen_locations.include?(next_location)
            # Do nothing
          else
            seen_locations << next_location
            queue << SolutionCandidate.new(next_location, current_solution_candidate, current_solution_candidate.step_count + 1)
          end
        end
      end
    end

    return seen_locations
  end

  def is_goal_state?(location)
    GOAL_LOCATION == location
  end

  def neighbour_locations(location)
    x, y = location.split(",").collect { |n| n.to_i }

    ([-1, 1].collect { |d| "#{x+d},#{y}" unless x+d < 0 } +
     [-1, 1].collect { |d| "#{x},#{y+d}" unless y+d < 0 })
      .compact
      .select { |location| is_open_space?(location) }
  end
end

cubicle_maze = CubicleMaze.new

puts "-- Part 1: --"
path = cubicle_maze.find_path
pp path
puts path.count - 1 # Subtract initial location

puts "-- Part 2: --"
reachable_locations = cubicle_maze.find_reachable_locations
pp reachable_locations
puts reachable_locations.count
