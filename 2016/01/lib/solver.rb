class Solver
  def solve(input)
    current_direction = 0
    step_counter = Hash.new(0)

    input.split(", ").each do |instruction|
      instruction_direction = instruction[0]
      instruction_steps = instruction[1..-1].to_i

      if "L" == instruction_direction
        current_direction = (current_direction + 1) % 4
      elsif "R" == instruction_direction
        current_direction = (current_direction - 1) % 4
      end

      step_counter[current_direction] = step_counter[current_direction] + instruction_steps
    end

    (step_counter[1] - step_counter[3]).abs + (step_counter[0] - step_counter[2]).abs
  end
end

class SecondSolver
  def solve(input)
    current_direction = 0
    direction_to_operator = {
      0 => :+,
      1 => :+,
      2 => :-,
      3 => :-,
    }
    location = [0, 0]
    direction_to_location_index = {
      0 => 1,
      1 => 0,
      2 => 1,
      3 => 0,
    }
    visited_locations = []
    result_location = nil

    input.split(", ").each do |instruction|
      instruction_direction = instruction[0]
      instruction_steps = instruction[1..-1].to_i

      if "L" == instruction_direction
        current_direction = (current_direction + 1) % 4
      elsif "R" == instruction_direction
        current_direction = (current_direction - 1) % 4
      end

      operator = direction_to_operator[current_direction]
      index = direction_to_location_index[current_direction]

      instruction_steps.times do
        location[index] = location[index].send(operator, 1)

        if visited_locations.include?(location)
          result_location = location
          break
        else
          visited_locations << location.dup
        end
      end

      break if !result_location.nil?
    end

    result_location.inject(0) { |r,n| r + n.abs } unless result_location.nil?
  end
end
