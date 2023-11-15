require 'pp'

# Example
# input = "10000"
# fill_length = 20

# Part 1
input = "11110010111001001"
# fill_length = 272

# Part 2
fill_length = 35651584

def dragon_curve(string)
  other_string = string.reverse.tr("01", "10")
  string + "0" + other_string
end

def checksum(string)
  result = ""

  string.chars.each_slice(2) do |a,b|
    if a == b
      result << "1"
    else
      result << "0"
    end
  end

  if result.length.even?
    return checksum(result)
  else
    return result
  end
end

result = input.dup
while result.length < fill_length
  result = dragon_curve(result)
end

result = result.slice(0, fill_length)

# pp result

pp checksum(result)
