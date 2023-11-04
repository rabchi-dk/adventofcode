require_relative 'lib/challenge'
require_relative 'lib/experimental_compression'

input = Challenge.new.input

puts "-- Part 1: --"
experimental_compression = ExperimentalCompression.new
puts experimental_compression.decompress(input).length

puts "-- Part 2: --"
experimental_compression_version_2 = ExperimentalCompressionVersion2.new
puts experimental_compression_version_2.decompressed_length(input)
