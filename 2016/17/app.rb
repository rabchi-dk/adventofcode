require 'digest'

class CachedMD5Generator
  def initialize(salt, filename, extra_iterations = nil)
    @salt = salt
    @hashes = nil
    @filename = filename
    @extra_iterations = extra_iterations || 0
  end

  def filename
    raise "Filename must be specified!" if @filename.nil? || @filename.empty?
    @filename
  end

  def hash(value)
    lazy_load_hashes

    cached_hash = @hashes[value.to_s]
    return cached_hash if cached_hash

    generated_hash = @salt + value.to_s
    0.step(@extra_iterations).each { generated_hash = Digest::MD5.hexdigest(generated_hash) }
    persist(value, generated_hash)
    return generated_hash
  end

  def lazy_load_hashes
    if @hashes.nil?
      @hashes = Hash.new
      File.readlines(filename).each do |line|
        index, hash = line.chomp.split(";")
        @hashes[index] = hash
      end if File.exist?(filename)
    end
  end

  def persist(index, hash)
    File.open(filename, "a") do |file|
      file.puts "#{index};#{hash}"
    end
  end
end

class Location
  def initialize(coordinates, path)
    @coordinates = coordinates
    @path = path
  end
  attr_reader :coordinates, :path
end

class VaultRoom
  OK_REGEX = Regexp.compile("[b-f]")
  DIRECTIONS = ["U", "D", "L", "R"]
  DIRECTION_TO_MOVEMENT_VECTOR = {
    "U" => [-1,  0],
    "D" => [ 1,  0],
    "L" => [ 0, -1],
    "R" => [ 0,  1],
  }

  def initialize(input)
    @input = input
    @cached_md5_generator = CachedMD5Generator.new(input, "cache.#{input}")
  end
  attr_reader :input

  def find_path
    initial_location = Location.new("0,0", [])

    queue = [initial_location]

    until queue.empty?
      current_location = queue.shift

      if is_goal_state?(current_location)
        return current_location.path
      end

      neighbour_locations(current_location).each do |next_location|
        queue << next_location
      end
    end

    return nil
  end

  def find_all_paths
    initial_location = Location.new("0,0", [])

    queue = [initial_location]

    result = []

    until queue.empty?
      current_location = queue.shift

      if is_goal_state?(current_location)
        result << current_location.path
      else
        neighbour_locations(current_location).each do |next_location|
          queue << next_location
        end
      end
    end

    return result
  end

  def is_goal_state?(location)
    "3,3" == location.coordinates
  end

  def neighbour_locations(location)
    coordinates = location.coordinates
    path = location.path
    x, y = coordinates.split(",").collect { |c| c.to_i }

    directions = doors_allow_moves(path).intersection(walls_allow_moves(coordinates))

    directions.collect do |direction|
      movement_vector = DIRECTION_TO_MOVEMENT_VECTOR[direction]
      neighbour_x = x + movement_vector[0]
      neighbour_y = y + movement_vector[1]
      Location.new("#{neighbour_x},#{neighbour_y}", path + [direction])
    end
  end

  def doors_allow_moves(path)
    hash = @cached_md5_generator.hash(path.join(""))

    hash.chars.slice(0, 4).collect.with_index { |c,i| OK_REGEX.match(c) ? DIRECTIONS[i] : nil }.compact
  end

  def walls_allow_moves(coordinates)
    x, y = coordinates.split(",").collect { |c| c.to_i }
    res = []
    res << "U" if 0 != x
    res << "D" if 3 != x
    res << "L" if 0 != y
    res << "R" if 3 != y
    res
  end
end

# Example
# vault_room = VaultRoom.new("hijkl")
# pp vault_room.doors_allow_moves([])
# pp vault_room.doors_allow_moves(["D", "U"])
# pp vault_room.walls_allow_moves("0,0")
# pp vault_room.walls_allow_moves("0,1")
# pp vault_room.walls_allow_moves("0,3")
# pp vault_room.walls_allow_moves("3,0")
# pp vault_room.walls_allow_moves("3,1")
# pp vault_room.walls_allow_moves("3,3")
# pp vault_room.neighbour_locations("0,0", [])
# pp vault_room.neighbour_locations("1,0", ["D"])
# pp vault_room.neighbour_locations("1,1", ["D", "R"])
# pp vault_room.neighbour_locations("0,0", ["D", "U"])
# pp vault_room.neighbour_locations("0,1", ["D", "U", "R"])
# pp vault_room.find_path

# Example 2
# vault_room = VaultRoom.new("ihgpwlah")
# puts vault_room.find_path.join("")

# Part 1
puts "-- Part 1: --"
vault_room = VaultRoom.new("mmsxrhfx")
puts vault_room.find_path.join("")

# Example for part 2
# vault_room = VaultRoom.new("ihgpwlah")
# longest_path = vault_room.find_all_paths.max { |path| path.length }
# pp longest_path
# puts longest_path.length

# Part 2
puts "-- Part 2: --"
vault_room = VaultRoom.new("mmsxrhfx")
longest_path = vault_room.find_all_paths.max { |path| path.length }
# puts longest_path.join("")
puts longest_path.length
