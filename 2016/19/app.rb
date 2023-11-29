require 'debug'
require 'pp'

class Elf
  def initialize(elf_position)
    @elf_position = elf_position
    @num_of_gifts = 1
    @next_elf = nil
  end
  attr_reader :elf_position
  attr_accessor :num_of_gifts, :next_elf

  def to_s
    "elf_position:#{elf_position}, num_of_gifts:#{num_of_gifts}"
  end
end

class ElfPartyPart1
  def initialize(elf_count)
    @first_elf = Elf.new(1)
    an_elf = @first_elf
    (2..elf_count).each do |c|
      another_elf = Elf.new(c)
      an_elf.next_elf = another_elf
      an_elf = another_elf
    end
    an_elf.next_elf = @first_elf
  end

  def find_next_elf_with_presents(an_elf)
    another_elf = an_elf.next_elf
    while another_elf.num_of_gifts == 0
      another_elf = another_elf.next_elf
    end
    another_elf
  end

  def elf_takes_presents(an_elf)
    another_elf = find_next_elf_with_presents(an_elf)
    an_elf.num_of_gifts = an_elf.num_of_gifts + another_elf.num_of_gifts
    another_elf.num_of_gifts = 0
  end

  def solve
    an_elf = nil
    another_elf = @first_elf
    while an_elf != another_elf
      an_elf = another_elf
      elf_takes_presents(an_elf)
      another_elf = find_next_elf_with_presents(an_elf)
    end
    an_elf
  end
end

class ElfPartyPart2Hacky
  def initialize(elf_count)
    @elf_list = []
    1.step(elf_count).each do |c|
      @elf_list << Elf.new(c)
    end
  end

  def solve
    itr = 0
    while @elf_list.length > 1
      itr = itr + 1

      if @elf_list.length > 6
        if @elf_list.length.odd?
          eliminate_one
        end

        one_go_round
      else
        while @elf_list.length > 1
          eliminate_one
        end
      end

      if itr % 5 == 0
        puts "Iterations: #{itr}. List length: #{@elf_list.length}."
      end
    end
    @elf_list.first
  end

  def eliminate_one
    this_elf_idx = 0

    take_from_elf_idx = (this_elf_idx + ((@elf_list.length) / 2)) % @elf_list.length

    this_elf = @elf_list[this_elf_idx]
    take_from_elf = @elf_list[take_from_elf_idx]

    # puts "TAKER: #{this_elf.to_s}"
    # puts "GIVER: #{take_from_elf.to_s}"

    this_elf.num_of_gifts = this_elf.num_of_gifts + take_from_elf.num_of_gifts
    @elf_list.delete_at(take_from_elf_idx)
    @elf_list = @elf_list[1..-1] + [@elf_list[0]]
  end

  def one_go_round
    left, right = @elf_list.each_slice(@elf_list.size / 2).to_a
    q_left = left.dup
    q_right = right.dup.reverse

    idx = 0
    while idx < (q_left.length / 3) * 2
      total_length = q_left.length + q_right.length

      giver_idx = (1 + ((total_length / 2) - q_right.length)) * -1
      puts "one_go_round idx: #{idx}. Left length: #{q_left.length}. Right length: #{q_right.length}. Total length/2: #{total_length/2}. Giver idx: #{giver_idx}." if idx <= 256 || idx % 10_000 == 0

      taker = q_left[idx]
      giver = q_right[giver_idx]
      # puts "TAKER: #{taker.to_s}"
      # puts "GIVER: #{giver.to_s}"
      raise "idx #{idx} led to a nil exception!" if giver.nil?

      q_right.delete_at(giver_idx)

      taker.num_of_gifts = taker.num_of_gifts + giver.num_of_gifts

      idx = idx + 1
    end

    @elf_list = left[idx..-1] + q_right.reverse + left[0..(idx-1)]
  end
end

class ElfPartyPart2Slow
  def initialize(elf_count)
    @elf_list = []
    1.step(elf_count).each do |c|
      @elf_list << Elf.new(c)
    end
  end

  def solve
    itr = 0
    this_elf_idx = 0
    while @elf_list.length > 1
      itr = itr + 1
      take_from_elf_idx = (this_elf_idx + ((@elf_list.length) / 2)) % @elf_list.length

      this_elf = @elf_list[this_elf_idx]
      take_from_elf = @elf_list[take_from_elf_idx]

      puts "TAKER: #{this_elf.to_s}"
      puts "GIVER: #{take_from_elf.to_s}"

      this_elf.num_of_gifts = this_elf.num_of_gifts + take_from_elf.num_of_gifts
      puts "Deleting at index: #{take_from_elf_idx}."
      @elf_list.delete_at(take_from_elf_idx) # TODO: I need to avoid this expensive call
      this_elf_idx = this_elf_idx - 1 if this_elf_idx > take_from_elf_idx # Refresh index after delete if necessary

      this_elf_idx = (this_elf_idx + 1) % @elf_list.length

      if itr % 500 == 0
        puts "Iterations: #{itr}. List length: #{@elf_list.length}."
      end
    end
    @elf_list.first
  end
end

# puts "-- Part 1 (Example): --"
# result_elf = ElfPartyPart1.new(5).solve
# puts result_elf.to_s

# puts "-- Part 1: --"
# result_elf = ElfPartyPart1.new(3001330).solve
# puts result_elf.to_s

# puts "-- Part 2 (Example): --"
# result_elf = ElfPartyPart2Slow.new(5).solve
# pp result_elf.to_s

puts "-- Part 2: --"
result_elf = ElfPartyPart2Hacky.new(3001330).solve
pp result_elf.to_s
