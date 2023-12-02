require_relative 'lib/challenge'
require 'debug'

challenge_input = Challenge.new.input

example_input = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"

have_red = 12
have_green = 13
have_blue = 14

id_sum = 0
powers = []

challenge_input.split("\n").each do |line|
  id = nil

  game_part, set_parts = line.split(":")
  if m = /^Game (\d+)/.match(game_part)
    id = m[1].to_i
  else
    raise "no game ID"
  end

  is_valid = true
  seen_red = 0
  seen_green = 0
  seen_blue = 0

  set_parts.split(";").each do |set_part|
    num_red = 0
    num_green = 0
    num_blue = 0

    color_parts = set_part.split(",")

    color_parts.each do |color_part|
      if color_part.include?("red")
        num_red = /(\d+)/.match(color_part)[1].to_i
        seen_red = num_red if num_red >= seen_red
        #pp [color_part, num_red]
      elsif color_part.include?("green")
        num_green = /(\d+)/.match(color_part)[1].to_i
        seen_green = num_green if num_green >= seen_green
        #pp [color_part, num_green]
      elsif color_part.include?("blue")
        num_blue = /(\d+)/.match(color_part)[1].to_i
        seen_blue = num_blue if num_blue >= seen_blue
        #pp [color_part, num_blue]
      else
        raise "color part with no colors"
      end
    end

    if num_red > have_red || num_green > have_green || num_blue > have_blue
      is_valid = false
    end
  end

  if is_valid
    #puts "OK LINE: #{line}"
    id_sum = id_sum + id
  else
    #puts "not ok line: #{line}"
  end

  power = seen_red * seen_green * seen_blue
  #pp [line, power]
  powers << power
end

puts id_sum
puts powers.sum
