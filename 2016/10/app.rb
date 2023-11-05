require_relative 'lib/challenge'

class Bot
  def initialize(id)
    @id = id
    @low_to = nil
    @high_to = nil
    @values = []
    @seen_values = []
  end
  attr_reader :id
  attr_accessor :low_to, :high_to

  def handle_value(value)
    #puts "#{id} handling value #{value}"
    @values << value
    @seen_values << value
    if @values.length == 2
      #puts "   bot #{id} comparing #{@values[0]} and #{@values[1]}"
      low_to.handle_value(@values.min)
      high_to.handle_value(@values.max)
      @values = []
    end
  end

  def has_seen_value?(value)
    @seen_values.include?(value)
  end
end

class OutputBucket
  def initialize(id)
    @id = id
    @values = []
  end
  attr_reader :id, :values

  def handle_value(value)
    #puts "#{id} handling value #{value}"
    @values << value
  end

  def has_seen_value?(value)
    @values.include?(value)
  end
end

class RobotRepsitory
  def initialize
    @bots_and_outputs = Hash.new
  end
  attr_reader :bots

  def get_or_create(id)
    existing = @bots_and_outputs[id]
    return existing unless existing.nil?

    bot_or_output = nil
    if id.start_with?("output")
      bot_or_output = OutputBucket.new(id)
    else
      bot_or_output = Bot.new(id)
    end

    @bots_and_outputs[id] = bot_or_output

    bot_or_output
  end

  def get(id)
    @bots_and_outputs.fetch(id)
  end

  def get_by_seen_value(value)
    @bots_and_outputs.values.select { |bot_or_output| bot_or_output.has_seen_value?(value) }
  end
end

class Solver
  def solve(input)
    robot_repository = setup_robot_repository(input)

    put_values_into_bots(robot_repository, input)

    "Part 1:\n" +
      robot_repository.get_by_seen_value(61).intersection(robot_repository.get_by_seen_value(17)).collect { |bot| bot.id }.join(", ") + "\n" +
      "Part 2:\n" +
      (robot_repository.get("output 0").values.first * robot_repository.get("output 1").values.first * robot_repository.get("output 2").values.first).to_s + "\n"
  end

  def put_values_into_bots(robot_repository, input)
    input.split("\n").each do |line|
      if m = /^value (\d+) goes to (bot \d+)$/.match(line)
        robot_repository.get(m[2]).handle_value(m[1].to_i)
      end
    end
  end

  def setup_robot_repository(input)
    robot_repository = RobotRepsitory.new

    input.split("\n").each do |line|
      if m = /^(bot \d+) gives low to ((?:output|bot) \d+) and high to ((?:bot|output) \d+)$/.match(line)
        bot = robot_repository.get_or_create(m[1])

        robot_repository.get_or_create(m[2])
        bot.low_to = robot_repository.get(m[2])

        robot_repository.get_or_create(m[3])
        bot.high_to = robot_repository.get(m[3])
      end
    end

    robot_repository
  end
end

input = Challenge.new.input
puts Solver.new.solve(input)
