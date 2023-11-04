require 'experimental_compression'

RSpec.describe "experimental compression" do
  context "decompression" do
    experimental_compression = ExperimentalCompression.new
    it "decompresses ADVENT" do
      expect(experimental_compression.decompress("ADVENT")).to eq("ADVENT")
    end

    it "decompresses A(1x5)BC" do
      expect(experimental_compression.decompress("A(1x5)BC")).to eq("ABBBBBC")
    end

    it "decompress (3x3)XYZ" do
      expect(experimental_compression.decompress("(3x3)XYZ")).to eq("XYZXYZXYZ")
    end

    it "decompress A(2x2)BCD(2x2)EFG" do
      expect(experimental_compression.decompress("A(2x2)BCD(2x2)EFG")).to eq("ABCBCDEFEFG")
    end

    it "decompress (6x1)(1x3)A" do
      expect(experimental_compression.decompress("(6x1)(1x3)A")).to eq("(1x3)A")
    end

    it "decompress X(8x2)(3x3)ABCY" do
      expect(experimental_compression.decompress("X(8x2)(3x3)ABCY")).to eq("X(3x3)ABC(3x3)ABCY")
    end
  end
end
