require 'debug'
require_relative '../solver'

describe "SolverPart2CountingAutomata" do
  context do
    let(:example01) { ["#", [1], 1] }
    let(:example02) { ["", [], 1] }
    let(:example03) { ["#", [], 0] }
    let(:example04) { [".", [], 1] }
    let(:example05) { ["?", [], 1] }
    let(:example06) { ["?", [1], 1] }
    let(:example07) { ["?.?", [1,1], 1] }
    solver = SolverPart2CountingAutomata.new

    it "solves example01" do
      condition, checksum_ints, expected_count = example01
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example02" do
      condition, checksum_ints, expected_count = example02
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example03" do
      condition, checksum_ints, expected_count = example03
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example04" do
      condition, checksum_ints, expected_count = example04
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example05" do
      condition, checksum_ints, expected_count = example05
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example06" do
      condition, checksum_ints, expected_count = example06
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example07" do
      condition, checksum_ints, expected_count = example07
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end
  end
end

describe "SolverPart2" do
  context do
    let(:example01) { ["#", [1], 1] }
    let(:example02) { ["", [], 1] }
    let(:example03) { ["#", [], 0] }
    let(:example04) { [".", [], 1] }
    let(:example05) { ["?", [], 1] }
    let(:example06) { ["?", [1], 1] }
    let(:example07) { ["?.?", [1,1], 1] }
    let(:example08) { ["??.??", [1,1], 4] }
    let(:example09) { ["???.###", [1,1,3], 1] }
    let(:example10) { [".??..??...?##.", [1,1,3], 4] }
    let(:line1) { ["???.###????.###????.###????.###????.###", [1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 3], 1] }
    let(:line2) { [".??.??.?##.?.??.??.?##.?.??.??.?##.?.??.??.?##.?.??.??.?##.", [1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 3], 16384] }
    let(:line6) { ["?###??????????###??????????###??????????###??????????###????????", [3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1, 3, 2, 1], 506250] }
    solver = SolverPart2.new

    it "solves example01" do
      condition, checksum_ints, expected_count = example01
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example02" do
      condition, checksum_ints, expected_count = example02
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example03" do
      condition, checksum_ints, expected_count = example03
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example04" do
      condition, checksum_ints, expected_count = example04
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example05" do
      condition, checksum_ints, expected_count = example05
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example06" do
      condition, checksum_ints, expected_count = example06
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example07" do
      condition, checksum_ints, expected_count = example07
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example08" do
      condition, checksum_ints, expected_count = example08
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example09" do
      condition, checksum_ints, expected_count = example09
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves example10" do
      condition, checksum_ints, expected_count = example10
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves line1" do
      condition, checksum_ints, expected_count = line1
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves line2" do
      condition, checksum_ints, expected_count = line2
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end

    it "solves line6" do
      condition, checksum_ints, expected_count = line6
      count = solver.solve_line(condition, checksum_ints)
      expect(count).to eq(expected_count)
    end
  end
end
