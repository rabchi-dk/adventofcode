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

  def sample
    @location_grid.flatten.compact.sample
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
  def shortest_distance_between(location_a, location_b)
    shortest_path_to = Hash.new
    queue = [location_a]

    while !queue.empty?
      current_location = queue.shift
      current_path = (shortest_path_to[current_location.coords] || []) + [current_location]

      if current_location.eql?(location_b)
        puts "GOAL! Went from #{location_a.to_s} to #{location_b.to_s} in #{current_path.length - 1} steps." # Subtract start location from path to get number of steps
        pp current_path.collect { |p| p.to_s }
        return
      end

      current_location.neighbour_locations.each do |neighbour_location|
        if shortest_path_to[neighbour_location.coords].nil? || shortest_path_to[neighbour_location.coords].length > current_path.length
          shortest_path_to[neighbour_location.coords] = current_path
          queue << neighbour_location
        end
      end
    end

    # puts "Shortest paths from #{location_a.to_s} to:"
    # pp shortest_path_to.to_a.collect { |k,v| [k, v.collect { |b| b.to_s }] }
  end
end

example_input = "###########
#0.1.....2#
#.#######.#
#4.......3#
###########
"

air_duct_parser = AirDuctParser.new

parser_result = air_duct_parser.parse_input(example_input)

#puts parser_result.to_s

air_duct_solver = AirDuctSolver.new

location_a = parser_result.get_by_number(0)
location_b = parser_result.get_by_number(1)
air_duct_solver.shortest_distance_between(location_a, location_b)

location_a = parser_result.get_by_number(4)
location_b = parser_result.get_by_number(1)
air_duct_solver.shortest_distance_between(location_a, location_b)

location_a = parser_result.get_by_number(1)
location_b = parser_result.get_by_number(2)
air_duct_solver.shortest_distance_between(location_a, location_b)

location_a = parser_result.get_by_number(2)
location_b = parser_result.get_by_number(3)
air_duct_solver.shortest_distance_between(location_a, location_b)
