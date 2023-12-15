require_relative '../lib'

describe "SolverPart1" do
  it "solves the example" do
    input = File.read("./input_example.txt")
    solver = SolverPart1.new
    result = solver.solve(input)
    expect(result).to eq(136)
  end

  it "solves the challenge" do
    input = File.read("./input_challenge.txt")
    solver = SolverPart1.new
    result = solver.solve(input)
    expect(result).to eq(107951)
  end
end

describe "SolverPart2" do
  it "solves the example" do
    input = File.read("./input_example.txt")
    solver = SolverPart2.new
    result = solver.solve(input)
    expect(result).to eq(64)
  end

  it "solves the challenge" do
    input = File.read("./input_challenge.txt")
    solver = SolverPart2.new
    result = solver.solve(input)
    expect(result).to eq(95736)
  end
end
