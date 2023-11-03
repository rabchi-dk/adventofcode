class Solver
  def initialize
    @keypad_layout = generate_keypad_layout
    calculate_max_keypad_indeces
  end

  def generate_keypad_layout
    [
      [  '1',   '2',   '3'],
      [  '4',   '5',   '6'],
      [  '7',   '8',   '9'],
    ]
  end

  def calculate_max_keypad_indeces
    @max_keypad_x = @keypad_layout.collect { |l| l.length-1 }.min
    @max_keypad_y = @keypad_layout.length-1
    [@max_keypad_x, @max_keypad_y]
  end

  def solve(start, input)
    result = ""
    current_digit = start

    input.split("\n").each do |line|
      current_digit = handle_line(current_digit, line)
      result << current_digit
    end

    result
  end

  def handle_line(digit, input)
    input.chars.each do |char|
      digit = move(digit, char)
    end

    digit
  end

  def move(digit, direction)
    index = digit_to_keypad_index(digit)

    movement_vector = direction_to_movement_vector(direction)
    index[0] = index[0] + movement_vector[0]
    index[1] = index[1] + movement_vector[1]

    new_digit = keypad_index_to_digit(index)
    digit = new_digit unless new_digit.nil?

    digit
  end

  def digit_to_keypad_index(digit)
    index_x_found = nil
    index_y_found = nil

    @keypad_layout.each_with_index do |row,y_index|
      x_index = row.index(digit)
      unless x_index.nil?
        index_y_found = y_index
        index_x_found = x_index
      end
    end

    [index_x_found, index_y_found]
  end

  def direction_to_movement_vector(direction)
    map = {
      "R" => [1, 0],
      "L" => [-1, 0],
      "U" => [0, -1],
      "D" => [0, 1],
    }
    map[direction]
  end

  def keypad_index_to_digit(index)
    if index[0] < 0 || index[1] < 0 || index[0] > @max_keypad_x || index[1] > @max_keypad_y
      return nil
    end

    @keypad_layout[index[1]][index[0]]
  end
end

class SecondSolver < Solver
  def generate_keypad_layout
    [
      [nil, nil, '1', nil, nil],
      [nil, '2', '3', '4', nil],
      ['5', '6', '7', '8', '9'],
      [nil, 'A', 'B', 'C', nil],
      [nil, nil, 'D', nil, nil],
    ]
  end
end
