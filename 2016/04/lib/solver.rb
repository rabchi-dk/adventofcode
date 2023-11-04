class Solver
  CHECKSUM_SKIP_CHARS = ['-']
  RoomStruct = Struct.new(:name, :id, :expected_checksum)

  def solve(input)
    input
      .split("\n")
      .collect { |line| parse_line(line) }
      .collect { |room| is_valid_room?(room) ? room.id : nil }
      .compact
      .inject(0) { |r,x| r = r +x }
  end

  def parse_line(line)
    if m = line.match(/^([a-z-]+)-([0-9]+)(\[[a-z]+\])/)
      name = m[1]
      id = m[2].to_i
      expected_checksum = m[3]
      RoomStruct.new(name, id, expected_checksum)
    else
      raise "parser error"
    end
  end

  def is_valid_room?(room)
    room.expected_checksum == calculate_checksum(room.name)
  end

  def calculate_checksum(string)
    counter = Hash.new(0)

    string.chars.each do |char|
      counter[char] = counter[char] + 1 unless CHECKSUM_SKIP_CHARS.include?(char)
    end

    "[" + counter
            .to_a
            .sort { |x,y| [-x[1],x[0]] <=> [-y[1],y[0]] }
            .take(5)
            .collect { |char,count| char }.join("") + "]"
  end
end
