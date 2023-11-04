require 'solver'

RSpec.describe "solver" do
  context "solve" do
    it "solves something 1 valid room" do
      solver = Solver.new
      expect(solver.solve("a-1[a]")).to eq(1)
    end

    it "solves something 2 valid rooms" do
      solver = Solver.new
      expect(solver.solve("a-1[a]\nb-2[b]")).to eq(3)
    end

    it "solves something 2 valid rooms (larger ids)" do
      solver = Solver.new
      expect(solver.solve("a-21[a]\nb-22[b]")).to eq(43)
    end

    it "solves something 2 valid rooms, 1 invalid room" do
      solver = Solver.new
      expect(solver.solve("a-1[a]\nb-2[b]\nx-3[q]")).to eq(3)
    end
  end

  context "calculate checksum" do
    it "calculates a checksum (aaa)" do
      solver = Solver.new
      expect(solver.calculate_checksum("aaa")).to eq("[a]")
    end

    it "calculates a checksum (ababa)" do
      solver = Solver.new
      expect(solver.calculate_checksum("ababa")).to eq("[ab]")
    end

    it "calculates a checksum (aaabbbb)" do
      solver = Solver.new
      expect(solver.calculate_checksum("aaabbbb")).to eq("[ba]")
    end

    it "calculates a checksum (abcdeffbcde) (max length = 5) (the single a is cut off)" do
      solver = Solver.new
      expect(solver.calculate_checksum("abcdeffbcde")).to eq("[bcdef]")
    end
  end

  context "decryption" do
    it "decrypts an example" do
      solver = Solver.new
      expect(solver.decrypt("qzmt-zixmtkozy-ivhz", 343)).to eq("very encrypted name")
    end
  end
end
