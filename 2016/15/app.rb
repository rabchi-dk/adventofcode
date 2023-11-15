require 'pp'

# Part 1
input = "Disc #1 has 13 positions; at time=0, it is at position 11.
Disc #2 has 5 positions; at time=0, it is at position 0.
Disc #3 has 17 positions; at time=0, it is at position 11.
Disc #4 has 3 positions; at time=0, it is at position 0.
Disc #5 has 7 positions; at time=0, it is at position 2.
Disc #6 has 19 positions; at time=0, it is at position 17."

# Part 2
input = input + "
Disc #7 has 11 positions; at time=0, it is at position 0."

class Disc
  def initialize(disc_num, num_of_positions, init_position)
    @disc_num = disc_num.to_i
    @num_of_positions = num_of_positions.to_i
    @init_position = init_position.to_i
  end
  attr_reader :disc_num, :num_of_positions, :init_position

  def position_when_start_time_is(time)
    (init_position + disc_num + time) % num_of_positions
  end
end

discs = []
input.split("\n").each do |line|
  if m = /^Disc #(\d+) has (\d+) positions; at time=(\d+), it is at position (\d+)\.$/.match(line)
    disc_num = m[1]
    disc_num_of_positions = m[2]
    disc_init_position = m[4]
    discs << Disc.new(disc_num, disc_num_of_positions, disc_init_position)
  else
    raise "Parse error!"
  end
end

# example_disc_1 = Disc.new(1, 5, 4)
# example_disc_2 = Disc.new(2, 2, 1)

# pp example_disc_1.position_at_time(5)
# pp example_disc_1.position_at_time(5)

(1..).each do |a_start_time|
  # puts "Progress: #{a_start_time}" if (a_start_time % 500) == 0
  if discs.all? { |d| d.position_when_start_time_is(a_start_time) == 0 }
    puts
    puts "a_start_time:#{a_start_time}"
    puts
    exit
  end
end
