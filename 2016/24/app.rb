require_relative 'lib/challenge'
require 'debug'

class AirDuctLocation
  def initialize(coords, number = nil)
    @coords = coords
    @number = number
    @north = nil
    #@north_west = nil
    @west = nil
    #@south_west = nil
    @south = nil
    #@south_east = nil
    @east = nil
    #@north_east = nil
  end
  attr_reader :coords
  #attr_accessor :north, :north_west, :west, :south_west, :south, :south_east, :east, :north_east
  attr_accessor :north, :west, :south, :east

  def to_s
    #return "(" + @coords[0].to_s + "," + @coords[1].to_s + ")[" + [[north, :N], [north_west, :NW], [west, :W], [south_west, :SW], [south, :S], [south_east, :SE], [east, :E], [north_east, :NE]].collect { |val, sym| val.nil? ? "" : sprintf("%s (%i,%i)", sym, val.coords[0], val.coords[1]) }.join(".") + "]"
    return "(" + @coords[0].to_s + "," + @coords[1].to_s + ")[" + [[north, :N], [west, :W], [south, :S], [east, :E]].collect { |val, sym| val.nil? ? "" : sprintf("%s (%i,%i)", sym, val.coords[0], val.coords[1]) }.join(".") + "]"
  end

  def neighbour_locations
    [north, west, south, east].compact
  end

  def eql?(other)
    other.is_a?(AirDuctLocation) && coords.eql?(other.coords)
  end
end

class AirDuctGraph
  def initialize(location_grid, number_map)
    @location_grid = location_grid
    @number_map = number_map
  end

  def to_s
    @location_grid.each do |row|
      row.each do |location|
        puts location.to_s
      end
    end
  end

  def get_by_coords(coords)
    @location_grid[coords[0]][coords[1]]
  end

  def get_by_number(number)
    @number_map[number]
  end

  def numbers
    @number_map.keys
  end
end

class AirDuctParser
  def parse_input(input)
    air_duct_numbers = Hash.new
    air_duct_locations = []

    input.split("\n").each.with_index do |row, row_index|
      air_duct_locations_row = []
      row.chars.each.with_index do |char, col_index|
        location_coords = [row_index, col_index].freeze
        case char
        when "#"
          air_duct_locations_row << nil
        when "."
          air_duct_locations_row << AirDuctLocation.new(location_coords)
        when /([0-9])/
          air_duct_number = $1.to_i
          air_duct_location = AirDuctLocation.new(location_coords, air_duct_number)
          air_duct_locations_row << air_duct_location
          air_duct_numbers[air_duct_number] = air_duct_location
        end
      end

      air_duct_locations << air_duct_locations_row
    end

    air_duct_locations.each.with_index do |row, row_index|
      row.each.with_index do |location, col_index|
        next if location.nil?

        if row_index > 0
          location.north = air_duct_locations[row_index-1][col_index]
        end
        # if row_index > 0 && col_index < row.length - 1
        #   location.north_east = air_duct_locations[row_index-1][col_index+1]
        # end
        if col_index < row.length - 1
          location.east = air_duct_locations[row_index][col_index+1]
        end
        # if col_index < row.length - 1 && row_index < air_duct_locations.length - 1
        #   location.south_east = air_duct_locations[row_index+1][col_index+1]
        # end
        if row_index < air_duct_locations.length - 1
          location.south = air_duct_locations[row_index+1][col_index]
        end
        # if row_index < air_duct_locations.length - 1 && col_index > 0
        #   location.south_west = air_duct_locations[row_index+1][col_index-1]
        # end
        if col_index > 0
          location.west = air_duct_locations[row_index][col_index-1]
        end
        # if row_index > 0 && col_index > 0
        #   location.north_west = air_duct_locations[row_index-1][col_index-1]
        # end
      end
    end

    AirDuctGraph.new(air_duct_locations, air_duct_numbers)
  end
end

class AirDuctSolver
  def initialize(graph)
    @graph = graph
    @distances_from_numbers = nil
  end

  def lazy_prepare_distances_from_numbers
    if @distances_from_numbers.nil?
      @distances_from_numbers = @graph.numbers.collect { |n| [n, distances_from(@graph.get_by_number(n))] }.to_h
    end
  end

  def solve(part = nil)
    lazy_prepare_distances_from_numbers
    numbers = @graph.numbers

    # Paths must start at 0
    possible_paths = numbers.permutation.select { |path| 0 == path[0] }

    if :part2 == part
      possible_paths = possible_paths.collect { |path| path + [0] }
    end

    possible_path_lengths = possible_paths.collect do |possible_path|
      length = 0

      possible_path.each_cons(2) do |pair|
        length = length + @distances_from_numbers[pair[0]][@graph.get_by_number(pair[1]).coords].length
      end

      length
    end

    possible_path_lengths.min
  end

  def distances_from(location_a)
    shortest_path_to = Hash.new
    queue = [location_a]

    while !queue.empty?
      current_location = queue.shift
      current_path = (shortest_path_to[current_location.coords] || []) + [current_location]

      current_location.neighbour_locations.each do |neighbour_location|
        if shortest_path_to[neighbour_location.coords].nil? || shortest_path_to[neighbour_location.coords].length > current_path.length
          shortest_path_to[neighbour_location.coords] = current_path
          queue << neighbour_location
        end
      end
    end

    shortest_path_to
  end
end



input = Challenge.new.input

# input = "###########
# #0.1.....2#
# #.#######.#
# #4.......3#
# ###########
# "

air_duct_parser = AirDuctParser.new

parser_result = air_duct_parser.parse_input(input)

#puts parser_result.to_s

air_duct_solver = AirDuctSolver.new(parser_result)

puts "Part 1:"
puts air_duct_solver.solve
puts "Part 2:"
puts air_duct_solver.solve(:part2)
