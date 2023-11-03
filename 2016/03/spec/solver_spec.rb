require 'solver'

RSpec.describe "solver" do
  context "solve" do
    it "does something" do
      solver = Solver.new
      expect(solver.solve).to eq(862)
    end
  end
end

RSpec.describe "second solver" do
  context "solve" do
    it "does vertical triangles" do
      solver = SecondSolver.new
      temp_possible_triangles = solver.possible_triangles
      expect(temp_possible_triangles[0]).to eq([785,272,801])
      expect(temp_possible_triangles[1]).to eq([516,511,791])
      # ...
      expect(temp_possible_triangles[3]).to eq([572,644,191])
    end

    it "solves the actual challenge" do
      solver = SecondSolver.new
      expect(solver.solve).to eq(1577)
    end
  end
end
