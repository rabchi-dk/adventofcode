require 'pp'
require 'debug'

ActionMove = Struct.new(:columns, :steps)

class Microchip
  def initialize(name)
    @name = name
  end
  attr_reader :name

  def to_s
    @name[0..1].upcase + "M"
  end

  def can_power?(other)
    false
  end

  def is_generator?
    false
  end

  def is_microchip?
    true
  end

  def can_coexist_with?(others)
    others.any? { |other| other.can_power?(self) } || others.none? { |other| other.is_generator? }
  end
end

class RTGenerator
  def initialize(name)
    @name = name
  end
  attr_reader :name

  def to_s
    @name[0..1].upcase + "G"
  end

  def can_power?(other)
    other.is_microchip? && name == other.name
  end

  def is_generator?
    true
  end

  def is_microchip?
    false
  end

  def can_coexist_with?(others)
    true
  end
end

class TestingFacilityState
  def initialize(floors_state, elevator_floor)
    @floors = floors_state
    @transposed_floors = @floors.transpose
    @elevator_floor = elevator_floor
  end
  attr_reader :elevator_floor

  def self.blank_testing_facility_state(num_of_floors, num_of_columns)
    blank_floors = 0.step(num_of_floors-1).collect { 0.step(num_of_columns-1).collect { nil } }
    self.new(blank_floors, 0)
  end

  def floors
    @floors.collect { |floor| floor.dup }
  end

  def transposed_floors
    @transposed_floors
  end

  def number_of_floors
    @floors.length
  end

  def floor_indeces
    @floors.length - 1
  end

  def number_of_columns
    @floors.first.length
  end

  def column_indeces
    @floors.first.length - 1
  end

  def put_microchip(floor, column, name)
    new_floors = floors
    new_floors[floor][column] = Microchip.new(name)
    TestingFacilityState.new(new_floors, elevator_floor)
  end

  def put_generator(floor, column, name)
    new_floors = floors
    new_floors[floor][column] = RTGenerator.new(name)
    TestingFacilityState.new(new_floors, elevator_floor)
  end

  def get_item_location_in_columns(columns)
    microchip_or_generator_floor_locations = columns.collect do |column|
      transposed_floors[column].find_index { |floor_value_of_this_column| !floor_value_of_this_column.nil? }
    end

    # Return nil if items are not on the same floor
    return nil if microchip_or_generator_floor_locations.uniq.length != 1

    microchip_or_generator_floor_locations.first
  end

  def floor_exists?(floor)
    0.step(floor_indeces).include?(floor)
  end

  def move_items(columns, steps)
    new_transposed_floors = transposed_floors.dup
    columns.each do |column|
      new_transposed_floors[column] = new_transposed_floors[column].rotate(steps * -1)
    end
    TestingFacilityState.new(new_transposed_floors.transpose, (elevator_floor + steps))
  end

  def all_chips_okay?
    @floors.collect do |floor|
      floor_items = floor.reject { |x| x.nil? }
      floor_items.collect { |x| x.can_coexist_with?(floor_items) }.all?
    end.all?
  end

  def is_goal_state?
    @floors.last.all? { |x| !x.nil? }
  end

  def lowest_floor_index_with_items
    @floors.find_index { |column| !column.all? { |value| value.nil? } }
  end

  def lowest_item_columns
    lfiwi = lowest_floor_index_with_items
    @floors[lfiwi].collect.with_index { |row_item, index| row_item.nil? ? nil : index }.compact
  end

  def to_s
    "E#{elevator_floor}\n" + @floors.reverse.collect do |columns|
      columns.collect { |value| value.nil? ? "  ." : value.to_s }.join("  ")
    end.join("\n")
  end

  def to_comparable_representation
    [elevator_floor] + @floors.collect do |floor|
      floor_items = floor.reject { |item| item.nil? }
      matching_items_count = floor_items.select { |item| item.is_generator? && floor_items.any? { |other_item| item.can_power?(other_item) } }.count
      generator_count = floor_items.select { |item| item.is_generator? }.count - matching_items_count
      microchip_count = floor_items.select { |item| item.is_microchip? }.count - matching_items_count
      [matching_items_count, generator_count, microchip_count]
    end
  end
end

class TestingFacilityMover
  def initialize
  end

  def do_action(testing_facility_state, action)
    item_location = testing_facility_state.get_item_location_in_columns(action.columns)

    # Return nil if items not found (on same floor)
    return nil if item_location.nil?

    # Return nil if elevator is not on same floor as items
    return nil if testing_facility_state.elevator_floor != item_location

    # Return nil if we would have moved items to a floor that does not exist
    return nil unless testing_facility_state.floor_exists?(item_location + action.steps)

    testing_facility_state_after_move = testing_facility_state.move_items(action.columns, action.steps)

    return nil unless testing_facility_state_after_move.all_chips_okay?

    return testing_facility_state_after_move
  end
end

class SolutionCandidate
  def initialize(testing_facility_state, previous_solution_candidate)
    @testing_facility_state = testing_facility_state
    @previous_solution_candidate = previous_solution_candidate
  end
  attr_reader :testing_facility_state, :previous_solution_candidate
end

class Solver
  def initialize(testing_facility_state)
    @mover = TestingFacilityMover.new
    @moves = all_possible_moves(testing_facility_state)
    @initial_testing_facility_state = testing_facility_state
  end
  attr_reader :mover, :moves, :initial_testing_facility_state

  def solve
    return nil if initial_testing_facility_state.nil?

    testing_facility_state = initial_testing_facility_state
    seen_testing_facility_states = [initial_testing_facility_state.to_comparable_representation]
    queue = []

    queue << SolutionCandidate.new(testing_facility_state, nil)

    while !queue.empty?
      solution_candidate = queue.shift
      testing_facility_state = solution_candidate.testing_facility_state

      # puts " -- CURRENT STATE --"
      # puts testing_facility_state.to_s

      if testing_facility_state.is_goal_state?
        # puts ">>> GOAL STATE <<<"
        return solution_candidate
      end

      moves.each do |move|
        new_testing_facility_state = mover.do_action(testing_facility_state, move)

        if new_testing_facility_state.nil?
          # Do nothing
        elsif seen_testing_facility_states.include?(new_testing_facility_state.to_comparable_representation)
          #puts "Skipping seen state!"
        else
          seen_testing_facility_states << new_testing_facility_state.to_comparable_representation
          queue << SolutionCandidate.new(new_testing_facility_state, solution_candidate)
        end
      end
    end

    return nil
  end

  def all_possible_moves(testing_facility_state)
    column_indeces = testing_facility_state.column_indeces

    number_of_floors_to_move_items = [-1, 1]
    column_numbers = 0.step(column_indeces).to_a
    possible_column_combinations = column_numbers.collect { |column_number| [column_number] } + (column_numbers.permutation(2).collect { |pair| pair.sort }.uniq)

    possible_moves = []
    possible_column_combinations.each do |columns_to_move|
      number_of_floors_to_move_items.each do |steps|
        possible_move = ActionMove.new(columns_to_move, steps)
        possible_moves << possible_move
      end
    end

    possible_moves
  end
end

#
# An example
#

# testing_facility_state = TestingFacilityState.blank_testing_facility_state(4, 4)
# testing_facility_state = testing_facility_state.put_microchip(0, 1, "hydrogen")
# testing_facility_state = testing_facility_state.put_microchip(0, 3, "lithium")
# testing_facility_state = testing_facility_state.put_generator(1, 0, "hydrogen")
# testing_facility_state = testing_facility_state.put_generator(2, 2, "lithium")

#
# My challenge
#
testing_facility_state = TestingFacilityState.blank_testing_facility_state(4, 10)
testing_facility_state = testing_facility_state.put_generator(0, 0, "polonium")
testing_facility_state = testing_facility_state.put_microchip(1, 1, "polonium") # Second floor
testing_facility_state = testing_facility_state.put_generator(0, 2, "thulium")
testing_facility_state = testing_facility_state.put_microchip(0, 3, "thulium")
testing_facility_state = testing_facility_state.put_generator(0, 4, "promethium")
testing_facility_state = testing_facility_state.put_microchip(1, 5, "promethium") # Second floor
testing_facility_state = testing_facility_state.put_generator(0, 6, "ruthenium")
testing_facility_state = testing_facility_state.put_microchip(0, 7, "ruthenium")
testing_facility_state = testing_facility_state.put_generator(0, 8, "cobalt")
testing_facility_state = testing_facility_state.put_microchip(0, 9, "cobalt")

solver = Solver.new(testing_facility_state)
solution = solver.solve
if solution.nil?
  puts "No solution found!"
else
  puts "Solution found!"
  puts
  puts

  solution_states = []
  current_solution = solution
  while !current_solution.nil?
    solution_states << current_solution.testing_facility_state
    current_solution = current_solution.previous_solution_candidate
  end

  solution_states.reverse.each do |x|
    puts x.to_s
    puts "---"
  end

  puts
  puts
  puts "step_count:#{solution_states.length - 1}" # Subtract initial state
end
