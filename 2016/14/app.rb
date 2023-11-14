require 'digest'

class CachedMD5GeneratorChallenge
  def initialize
    @salt = "ahsbgdzn"
    @hashes = nil
  end

  def hash(index)
    lazy_load_hashes

    cached_hash = @hashes[index.to_s]
    return cached_hash if cached_hash

    generated_hash = Digest::MD5.hexdigest(@salt + index.to_s)
    persist(index, generated_hash)
    return generated_hash
  end

  def lazy_load_hashes
    if @hashes.nil?
      @hashes = Hash.new
      File.readlines("cache.hashes.challenge").each do |line|
        index, hash = line.chomp.split(";")
        @hashes[index] = hash
      end if File.exist?("cache.hashes.challenge")
    end
  end

  def persist(index, hash)
    File.open("cache.hashes.challenge", "a") do |file|
      file.puts "#{index};#{hash}"
    end
  end
end

class CachedMD5GeneratorChallengePart2
  def initialize
    @salt = "ahsbgdzn"
    @hashes = nil
  end

  def hash(index)
    lazy_load_hashes

    cached_hash = @hashes[index.to_s]
    return cached_hash if cached_hash

    generated_hash = @salt + index.to_s
    0.step(2016).each { generated_hash = Digest::MD5.hexdigest(generated_hash) }
    persist(index, generated_hash)
    return generated_hash
  end

  def lazy_load_hashes
    if @hashes.nil?
      @hashes = Hash.new
      File.readlines("cache.hashes.challenge.part2").each do |line|
        index, hash = line.chomp.split(";")
        @hashes[index] = hash
      end if File.exist?("cache.hashes.challenge.part2")
    end
  end

  def persist(index, hash)
    File.open("cache.hashes.challenge.part2", "a") do |file|
      file.puts "#{index};#{hash}"
    end
  end
end

class CachedMD5GeneratorExample
  def initialize
    @salt = "abc"
    @hashes = nil
  end

  def hash(index)
    lazy_load_hashes

    cached_hash = @hashes[index.to_s]
    return cached_hash if cached_hash

    generated_hash = Digest::MD5.hexdigest(@salt + index.to_s)
    persist(index, generated_hash)
    return generated_hash
  end

  def lazy_load_hashes
    if @hashes.nil?
      @hashes = Hash.new
      File.readlines("cache.hashes.example").each do |line|
        index, hash = line.chomp.split(";")
        @hashes[index] = hash
      end if File.exist?("cache.hashes.example")
    end
  end

  def persist(index, hash)
    File.open("cache.hashes.example", "a") do |file|
      file.puts "#{index};#{hash}"
    end
  end
end

class Solver
  def solve
    repeating_char_regex = generate_repeating_char_regex

    # md5gen = CachedMD5GeneratorExample.new # Example
    # md5gen = CachedMD5GeneratorChallenge.new # Part 1
    md5gen = CachedMD5GeneratorChallengePart2.new # Part 2

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
