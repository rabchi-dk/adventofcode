class Solver
  CHECKSUM_SKIP_CHARS = ['-']
  RoomStruct = Struct.new(:encrypted_name, :id, :expected_checksum)

  def solve_part1(input)
    parse_lines(input)
      .collect { |room| is_valid_room?(room) ? room.id : nil }
      .compact
      .inject(0) { |r,x| r = r +x }
  end

  def solve_part2(input)
    parse_lines(input)
      .collect { |room| is_valid_room?(room) ? room : nil }
      .compact
      .collect { |room| [room.id, decrypt(room.encrypted_name, room.id)] }
      .select { |id, name| ["north","pole","object","storage"].all? { |search_term| name.include?(search_term) } }
  end

  def parse_lines(input)
    input
      .split("\n")
      .collect { |line| parse_line(line) }
  end

  def parse_line(line)
    if m = line.match(/^([a-z-]+)-([0-9]+)(\[[a-z]+\])/)
      encrypted_name = m[1]
      id = m[2].to_i
      expected_checksum = m[3]
      RoomStruct.new(encrypted_name, id, expected_checksum)
    else
      raise "parser error"
    end
  end

  def is_valid_room?(room)
    room.expected_checksum == calculate_checksum(room.encrypted_name)
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

  def decrypt(name, id)
    min_ord = ("a".ord)
    max_ord = ("z".ord)
    number_of_chars = max_ord - min_ord + 1
    name.chars.collect { |char| "-" == char ? " " : (((char.ord - min_ord + id) % number_of_chars) + min_ord).chr }.join("")
  end
end
