class Solver
  def solve(input)
    triangles = possible_triangles(input).select do |possible_triangle|
      [[0,1,2],[1,2,0],[2,0,1]].all? do |a,b,c|
        possible_triangle[a] + possible_triangle[b] > possible_triangle[c]
      end
    end
    triangles.count
  end

  def possible_triangles(input)
    input.split("\n").collect do |line|
      line.sub(/ +/, "").split(/ +/).collect { |n| n.to_i }
    end
  end
end

class SecondSolver < Solver
  def possible_triangles(input)
    horizontal_triangles = super

    index = 0
    step = 3
    vertical_triangles = []
    while index < horizontal_triangles.length-1
      a = horizontal_triangles.slice(index, step).transpose
      vertical_triangles = vertical_triangles + a
      index = index + step
    end

    vertical_triangles
  end
end
