require 'debug'

class ExperimentalCompression
  def decompress(string)
    result = ""
    i = 0
    loop do
      current_char = string[i]
      break if current_char.nil? # End of string

      # puts "   current_char:#{current_char}"

      if "(" == current_char
        # puts "   matching against string: " + string[i..-1] + "<"
        if m = /^\((\d+)x(\d+)\)/.match(string[i..-1])
          # puts "   match found: " + m[0]
          i = i + m[0].length
          data_length = m[1].to_i
          times_to_repeat = m[2].to_i
          string_to_expand = string.slice(i, data_length)
          i = i + data_length
          result = result + (string_to_expand * times_to_repeat)
        else
          raise "parser error!"
        end
      else
        result = result + current_char
        i = i + 1
      end
      # puts "   result:#{result}"
    end

    result
  end
end

class ExperimentalCompressionVersion2
  def decompressed_length(string)
    result = 0
    i = 0
    loop do
      current_char = string[i]
      break if current_char.nil? # End of string

      # puts "   current_char:#{current_char}"

      if "(" == current_char
        # puts "   matching against string: " + string[i..-1] + "<"
        if m = /^\((\d+)x(\d+)\)/.match(string[i..-1])
          # puts "   match found: " + m[0]
          i = i + m[0].length
          data_length = m[1].to_i
          times_to_repeat = m[2].to_i
          string_to_expand = string.slice(i, data_length)
          i = i + data_length
          result = result + (times_to_repeat * decompressed_length(string_to_expand))
        else
          raise "parser error!"
        end
      else
        i = i + 1
        result = result + 1
      end
    end

    result
  end
end
