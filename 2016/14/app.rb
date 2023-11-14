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

  def hash(index)
    lazy_load_hashes

    cached_hash = @hashes[index.to_s]
    return cached_hash if cached_hash

    generated_hash = @salt + index.to_s
    0.step(@extra_iterations).each { generated_hash = Digest::MD5.hexdigest(generated_hash) }
    persist(index, generated_hash)
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

class Solver
  def solve
    repeating_char_regex = generate_repeating_char_regex

    # md5gen = CachedMD5Generator.new("abc", "cache.hashes.example") # Example (broken)
    # md5gen = CachedMD5Generator.new("ahsbgdzn", "cache.hashes.challenge") # Part 1
    md5gen = CachedMD5Generator.new("ahsbgdzn", "cache.hashes.challenge.part2", 2016) # Part 2

    matches = []
    key_matches = []

    (0..).each do |i|
      md5 = md5gen.hash(i)

      if m = repeating_char_regex.match(md5)
        matched_chars = m[1]
        matched_char = matched_chars[0]
        matched_length = matched_chars.length

        matches << [i, matched_length, matched_char]

        if matched_chars.length == 5
          corresponding_triple_matches = matches
                                           .select { |a,b,c| (a+1).step(a+1000).include?(i) && b == 3 && matched_char == c }

          key_matches = (key_matches + corresponding_triple_matches).uniq
        end
      end

      break if key_matches.length >= 64
    end

    return key_matches.sort_by { |a,b,c| a }
  end

  def generate_repeating_char_regex
    Regexp.compile("(" + (("0".."9").to_a + ("a".."f").to_a).collect { |c| "#{c}{3}(?:#{c}{2})?" }.join("|") + ")")
  end
end

the_key_matches = Solver.new.solve
pp the_key_matches[0..63].length
puts "---"
pp the_key_matches[63]
