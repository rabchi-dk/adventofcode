require 'debug'

class SolverPart1
  def solve(input)
    lines = input.split("\n")
    chars = lines.collect { |line| line.chars }
    cols = chars.transpose
    total_score = 0
    cols.each.with_index do |col, col_index|
      col_score = 0
      score = col.length
      col.each.with_index do |char, row_index|

        row_score = col.length - row_index
        if "O" == char
          col_score = col_score + score
          score = score - 1
        elsif "#" == char
          score = row_score - 1

        end
      end
      total_score += col_score
      puts "#{col_index}: #{col.join('')}: #{col_score}: #{total_score}"
    end
    total_score
  end
end

class SolverPart2
  def solve(input)
    board = input.split("\n").collect { |line| line.chars }

    boards = [board]

    1.step(1000) do |i|
      board = cycle(board)
      puts "Cycle #{i}:"
      #pp board
      puts score(board)
      puts "---"
      if boards.include?(board)
        puts "found same board at index: #{boards.index(board)}"
        puts "we're at cycle #{i}"
        cycle_start_index = boards.index(board)
        puts "cycle_start_index: #{cycle_start_index}"
        cycle_length = i - (cycle_start_index)
        cycles_left = (1_000_000_000 - cycle_start_index)
        where_we_are_in_cycle_index = cycles_left % cycle_length
        final_board = boards[where_we_are_in_cycle_index + cycle_start_index]
        final_board_score = score(final_board)
        puts "cycle_length: #{cycle_length}"
        puts "cycles_left: #{cycles_left}"
        puts "where_we_are_in_cycle_index: #{where_we_are_in_cycle_index}"
        puts "final_board_score: #{final_board_score}"
        return final_board_score
      else
        boards << board
      end
    end
  end

  def score(board)
    total_score = 0
    max_row = board.length
    board.each.with_index do |row, index|
      row_number = index
      total_score = total_score + (row.count { |c| "O" == c } * (max_row - row_number))
    end
    total_score
  end

  def cycle(board)
    4.times do
      board = move_stuff(board)
      board = turn_clockwise(board)
    end
    board
  end

  def turn_clockwise(board)
    board.transpose.collect { |a| a.reverse }
  end

  def move_stuff(board)
    return board.transpose.collect { |board_line| move_line_north(board_line) }.transpose
  end

  def move_line_north(board_line)
    board_line_tail = board_line.dup
    result = []
    i = 0
    while !board_line_tail.empty?
      i = board_line_tail.find_index("#") || board_line_tail.length-1
      result = result + board_line_tail.take(i+1).sort.reverse
      board_line_tail = board_line_tail.drop(i+1)
    end
    return result
  end
end
