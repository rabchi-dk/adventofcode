require 'solver'

RSpec.describe "solver" do
  context "hashing" do
    it "finds relevant index (example 1)" do
      solver = Solver.new
      expect(solver.find_interesting_hash("abc", 3231929-10).index).to eq(3231929)
    end

    it "finds relevant index (example 2)" do
      solver = Solver.new
      expect(solver.find_interesting_hash("abc", 5017308-10).index).to eq(5017308)
    end

    it "finds relevant index (example 2)" do
      solver = Solver.new
      expect(solver.find_interesting_hash("abc", 5278568-10).index).to eq(5278568)
    end
  end

  context "solve part 1" do
    it "solves an example" do
      solver = Solver.new
      expect(solver.solve_part1("abc")).to eq("18f47a30")
    end
  end
end
