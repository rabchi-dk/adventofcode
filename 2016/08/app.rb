require_relative 'lib/challenge'

class LittleScreen
  NUM_COLS = 50
  NUM_ROWS = 6

  def initialize
    @pixels = (1..NUM_ROWS).collect { (1..NUM_COLS).collect { false } }
  end

  def rect(x, y)
    x = [x, NUM_COLS].min
    @pixels[0, y] = @pixels[0, y].collect { |col| col.fill(true, 0, x) }
  end

  def rotate_y(y, num)
    num = num * -1
    @pixels[y] = @pixels[y].rotate(num)
  end

  def rotate_x(x, num)
    num = num * -1
    transposed_pixels = @pixels.transpose
    transposed_pixels[x] = transposed_pixels[x].rotate(num)
    @pixels = transposed_pixels.transpose
  end

  def to_s
    @pixels.collect { |row| row.collect { |p| p ? "#" : "." }.join("") }.join("\n")
  end

  def number_of_pixels_lit
    @pixels.inject(0) { |r, row| r = r + row.inject(0) { |rr, p| rr = rr + (p ? 1 : 0) } }
  end
end

# # Example
# ls = LittleScreen.new
# ls.rect(3, 2)
# ls.rotate_x(1, 1)
# ls.rotate_y(0, 4)
# ls.rotate_x(1, 1)
# puts ls.to_s
# puts ls.number_of_pixels_lit

input = Challenge.new.input

little_screen = LittleScreen.new

input.split("\n").each do |line|
  if m = /^rect (\d+)x(\d+)$/.match(line)
    little_screen.rect(m[1].to_i, m[2].to_i)
  elsif m = /^rotate row y=(\d+) by (\d+)$/.match(line)
    little_screen.rotate_y(m[1].to_i, m[2].to_i)
  elsif m = /^rotate column x=(\d+) by (\d+)$/.match(line)
    little_screen.rotate_x(m[1].to_i, m[2].to_i)
  else
    raise "parser error!"
  end
end

puts little_screen.to_s
puts little_screen.number_of_pixels_lit
