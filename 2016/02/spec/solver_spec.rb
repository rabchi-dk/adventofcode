require 'solver'
require 'debug'

THE_ACTUAL_CHALLANGE = "LURLLLLLDUULRDDDRLRDDDUDDUULLRLULRURLRRDULUUURDUURLRDRRURUURUDDRDLRRLDDDDLLDURLDUUUDRDDDLULLDDLRLRRRLDLDDDDDLUUUDLUULRDUDLDRRRUDUDDRULURULDRUDLDUUUDLUDURUURRUUDRLDURRULURRURUUDDLRLDDDDRDRLDDLURLRDDLUDRLLRURRURRRURURRLLRLDRDLULLUDLUDRURDLRDUUDDUUDRLUDDLRLUDLLURDRUDDLRURDULLLUDDURULDRLUDLUDLULRRUUDDLDRLLUULDDURLURRRRUUDRUDLLDRUDLRRDUDUUURRULLDLDDRLUURLDUDDRLDRLDULDDURDLUUDRRLDRLLLRRRDLLLLURDLLLUDRUULUULLRLRDLULRLURLURRRDRLLDLDRLLRLULRDDDLUDDLLLRRLLLUURLDRULLDURDLULUDLRLDLUDURLLLURUUUDRRRULRDURLLURRLDLRLDLDRRUUDRDDDDDRDUUDULUL
RRURLURRULLUDUULUUURURULLDLRLRRULRUDUDDLLLRRRRLRUDUUUUDULUDRULDDUDLURLRRLLDLURLRDLDUULRDLLLDLLULLURLLURURULUDLDUDLUULDDLDRLRRUURRRLLRRLRULRRLDLDLRDULDLLDRRULRDRDUDUUUDUUDDRUUUDDLRDULLULDULUUUDDUULRLDLRLUUUUURDLULDLUUUULLLLRRRLDLLDLUDDULRULLRDURDRDRRRDDDLRDDULDLURLDLUDRRLDDDLULLRULDRULRURDURRUDUUULDRLRRUDDLULDLUULULRDRDULLLDULULDUDLDRLLLRLRURUDLUDDDURDUDDDULDRLUDRDRDRLRDDDDRLDRULLURUDRLLUDRLDDDLRLRDLDDUULRUDRLUULRULRLDLRLLULLUDULRLDRURDD
UUUUUURRDLLRUDUDURLRDDDURRRRULRLRUURLLLUULRUDLLRUUDURURUDRDLDLDRDUDUDRLUUDUUUDDURRRDRUDDUURDLRDRLDRRULULLLUDRDLLUULURULRULDRDRRLURULLDURUURDDRDLLDDDDULDULUULLRULRLDURLDDLULRLRRRLLURRLDLLULLDULRULLDLRULDDLUDDDLDDURUUUURDLLRURDURDUUDRULDUULLUUULLULLURLRDRLLRULLLLRRRRULDRULLUURLDRLRRDLDDRLRDURDRRDDDRRUDRLUULLLULRDDLDRRLRUDLRRLDULULRRDDURULLRULDUDRLRUUUULURLRLRDDDUUDDULLULLDDUDRLRDDRDRLDUURLRUULUULDUDDURDDLLLURUULLRDLRRDRDDDUDDRDLRRDDUURDUULUDDDDUUDDLULLDRDDLULLUDLDDURRULDUDRRUURRDLRLLDDRRLUUUDDUUDUDDDDDDDLULURRUULURLLUURUDUDDULURDDLRDDRRULLLDRRDLURURLRRRDDLDUUDR
URLLRULULULULDUULDLLRDUDDRRLRLLLULUDDUDLLLRURLLLLURRLRRDLULRUDDRLRRLLRDLRRULDLULRRRRUUDDRURLRUUDLRRULDDDLRULDURLDURLRLDDULURDDDDULDRLLUDRULRDDLUUUDUDUDDRRUDUURUURLUUULRLULUURURRLRUUULDDLURULRRRRDULUDLDRLLUURRRLLURDLDLLDUDRDRLLUDLDDLRLDLRUDUULDRRLLULDRRULLULURRLDLUUDLUDDRLURDDUDRDUDDDULLDRUDLRDLRDURUULRRDRUUULRUURDURLDUDRDLLRUULUULRDDUDLRDUUUUULDDDDDRRULRURLLRLLUUDLUDDUULDRULDLDUURUDUDLRULULUULLLLRLULUDDDRRLLDRUUDRLDDDRDDURRDDDULURDLDLUDDUULUUURDULDLLULRRUURDDUDRUULDLRLURUDLRDLLLDRLDUURUDUDRLLLDDDULLUDUUULLUUUDLRRRURRRRRDUULLUURRDUU
UDULUUDLDURRUDDUDRDDRRUULRRULULURRDDRUULDRLDUDDRRRRDLRURLLLRLRRLLLULDURRDLLDUDDULDLURLURUURLLLDUURRUUDLLLUDRUDLDDRLRRDLRLDDDULLRUURUUUDRRDLLLRRULDRURLRDLLUDRLLULRDLDDLLRRUDURULRLRLDRUDDLUUDRLDDRUDULLLURLRDLRUUDRRUUDUDRDDRDRDDLRULULURLRULDRURLURLRDRDUUDUDUULDDRLUUURULRDUDRUDRULUDDULLRDDRRUULRLDDLUUUUDUDLLLDULRRLRDDDLULRDUDRLDLURRUUDULUDRURUDDLUUUDDRLRLRLURDLDDRLRURRLLLRDRLRUUDRRRLUDLDLDDDLDULDRLURDURULURUDDDUDUULRLLDRLDDDDRULRDRLUUURD"

RSpec.describe "solver" do
  context "move" do
    it "handles top border" do
      solver = Solver.new
      result = solver.move("1", "U")
      expect(result).to eq("1")

      solver = Solver.new
      result = solver.move("2", "U")
      expect(result).to eq("2")

      solver = Solver.new
      result = solver.move("3", "U")
      expect(result).to eq("3")
    end

    it "handles right border" do
      solver = Solver.new
      result = solver.move("3", "R")
      expect(result).to eq("3")

      solver = Solver.new
      result = solver.move("6", "R")
      expect(result).to eq("6")

      solver = Solver.new
      result = solver.move("9", "R")
      expect(result).to eq("9")
    end

    it "handles bottom border" do
      solver = Solver.new
      result = solver.move("7", "D")
      expect(result).to eq("7")

      solver = Solver.new
      result = solver.move("8", "D")
      expect(result).to eq("8")

      solver = Solver.new
      result = solver.move("9", "D")
      expect(result).to eq("9")
    end

    it "handles left border" do
      solver = Solver.new
      result = solver.move("1", "L")
      expect(result).to eq("1")

      solver = Solver.new
      result = solver.move("4", "L")
      expect(result).to eq("4")

      solver = Solver.new
      result = solver.move("7", "L")
      expect(result).to eq("7")
    end
  end

  context "handle_line" do
    it "handles example 1 (ULL)" do
      solver = Solver.new
      result = solver.handle_line("5", "ULL")
      expect(result).to eq("1")
    end

    it "handles example 2 (RRDDD)" do
      solver = Solver.new
      result = solver.handle_line("1", "RRDDD")
      expect(result).to eq("9")
    end

    it "handles example 3 (LURDL)" do
      solver = Solver.new
      result = solver.handle_line("9", "LURDL")
      expect(result).to eq("8")
    end

    it "handles example 4 (UUUUD)" do
      solver = Solver.new
      result = solver.handle_line("8", "UUUUD")
      expect(result).to eq("5")
    end
  end

  context "solve" do
    it "solves example 1" do
      solver = Solver.new
      result = solver.solve("5", "ULL\nRRDDD\nLURDL\nUUUUD")
      expect(result).to eq("1985")
    end
  end

  context "actual challange" do
    it "solves an actual challenge" do
      solver = Solver.new
      expect(solver.solve("5", THE_ACTUAL_CHALLANGE)).to eq("19636")
    end
  end
end

RSpec.describe "secondsolver" do
  context "move" do
    it "handles moving left" do
      solver = SecondSolver.new

      result = solver.move("1", "L")
      expect(result).to eq("1")

      result = solver.move("2", "L")
      expect(result).to eq("2")

      result = solver.move("3", "L")
      expect(result).to eq("2")

      result = solver.move("4", "L")
      expect(result).to eq("3")

      result = solver.move("5", "L")
      expect(result).to eq("5")

      result = solver.move("6", "L")
      expect(result).to eq("5")

      result = solver.move("7", "L")
      expect(result).to eq("6")

      result = solver.move("8", "L")
      expect(result).to eq("7")

      result = solver.move("9", "L")
      expect(result).to eq("8")

      result = solver.move("A", "L")
      expect(result).to eq("A")

      result = solver.move("B", "L")
      expect(result).to eq("A")

      result = solver.move("C", "L")
      expect(result).to eq("B")

      result = solver.move("D", "L")
      expect(result).to eq("D")
    end

    it "handles moving right" do
      solver = SecondSolver.new

      result = solver.move("1", "R")
      expect(result).to eq("1")

      result = solver.move("2", "R")
      expect(result).to eq("3")

      result = solver.move("3", "R")
      expect(result).to eq("4")

      result = solver.move("4", "R")
      expect(result).to eq("4")

      result = solver.move("5", "R")
      expect(result).to eq("6")

      result = solver.move("6", "R")
      expect(result).to eq("7")

      result = solver.move("7", "R")
      expect(result).to eq("8")

      result = solver.move("8", "R")
      expect(result).to eq("9")

      result = solver.move("9", "R")
      expect(result).to eq("9")

      result = solver.move("A", "R")
      expect(result).to eq("B")

      result = solver.move("B", "R")
      expect(result).to eq("C")

      result = solver.move("C", "R")
      expect(result).to eq("C")

      result = solver.move("D", "R")
      expect(result).to eq("D")
    end

    it "handles moving down" do
      solver = SecondSolver.new

      result = solver.move("1", "D")
      expect(result).to eq("3")

      result = solver.move("2", "D")
      expect(result).to eq("6")

      result = solver.move("3", "D")
      expect(result).to eq("7")

      result = solver.move("4", "D")
      expect(result).to eq("8")

      result = solver.move("5", "D")
      expect(result).to eq("5")

      result = solver.move("6", "D")
      expect(result).to eq("A")

      result = solver.move("7", "D")
      expect(result).to eq("B")

      result = solver.move("8", "D")
      expect(result).to eq("C")

      result = solver.move("9", "D")
      expect(result).to eq("9")

      result = solver.move("A", "D")
      expect(result).to eq("A")

      result = solver.move("B", "D")
      expect(result).to eq("D")

      result = solver.move("C", "D")
      expect(result).to eq("C")

      result = solver.move("D", "D")
      expect(result).to eq("D")
    end

    it "handles moving up" do
      solver = SecondSolver.new

      result = solver.move("1", "U")
      expect(result).to eq("1")

      result = solver.move("2", "U")
      expect(result).to eq("2")

      result = solver.move("3", "U")
      expect(result).to eq("1")

      result = solver.move("4", "U")
      expect(result).to eq("4")

      result = solver.move("5", "U")
      expect(result).to eq("5")

      result = solver.move("6", "U")
      expect(result).to eq("2")

      result = solver.move("7", "U")
      expect(result).to eq("3")

      result = solver.move("8", "U")
      expect(result).to eq("4")

      result = solver.move("9", "U")
      expect(result).to eq("9")

      result = solver.move("A", "U")
      expect(result).to eq("6")

      result = solver.move("B", "U")
      expect(result).to eq("7")

      result = solver.move("C", "U")
      expect(result).to eq("8")

      result = solver.move("D", "U")
      expect(result).to eq("B")
    end
  end

  context "handle_line" do
    it "handles example 1 (ULL)" do
      solver = SecondSolver.new
      expect(solver.handle_line("5", "ULL")).to eq("5")
    end

    it "handles example 2 (RRDDD)" do
      solver = SecondSolver.new
      expect(solver.handle_line("5", "RRDDD")).to eq("D")
    end

    it "handles example 3 (LURDL)" do
      solver = SecondSolver.new
      expect(solver.handle_line("D", "LURDL")).to eq("B")
    end

    it "handles example 4 (UUUUD)" do
      solver = SecondSolver.new
      expect(solver.handle_line("B", "UUUUD")).to eq("3")
    end
  end

  context "solve" do
    it "solves example 1" do
      solver = SecondSolver.new
      expect(solver.solve("5", "ULL\nRRDDD\nLURDL\nUUUUD")).to eq("5DB3")
    end
  end

  context "actual challange" do
    it "solves an actual challenge" do
      solver = SecondSolver.new
      expect(solver.solve("5", THE_ACTUAL_CHALLANGE)).to eq("3CC43")
    end
  end

  context "digit_to_keypad_index" do
    it "handles digit 5" do
      solver = SecondSolver.new
      expect(solver.digit_to_keypad_index("5")).to eq([0, 2])
    end

    it "handles digit 6" do
      solver = SecondSolver.new
      expect(solver.digit_to_keypad_index("6")).to eq([1, 2])
    end

    it "handles digit D" do
      solver = SecondSolver.new
      expect(solver.digit_to_keypad_index("D")).to eq([2, 4])
    end
  end

  context "keypad_index_to_digit" do
    it "handles 0,2" do
      solver = SecondSolver.new
      expect(solver.keypad_index_to_digit([0, 2])).to eq("5")
    end

    it "handles 1,2" do
      solver = SecondSolver.new
      expect(solver.keypad_index_to_digit([1, 2])).to eq("6")
    end

    it "handles 2,4" do
      solver = SecondSolver.new
      expect(solver.keypad_index_to_digit([2, 4])).to eq("D")
    end
  end
end
