defmodule Green.DnaTest do
  use ExUnit.Case

  alias Green.Dna

  describe "read/1" do
    test "it reads the strand" do
      expected_result = ["<svg", "0", "1", "</svg>", ""]
      result = Dna.read("AAAAACAADAABAA")
      assert expected_result == result
    end
    test "it reads this strand" do
      strand = "AAAAAEAAHAADAACAACAAFAAHAADAACAACAAGAAB"
      expected_result = ["<svg", "width", "=", "1", "0", "0", "height", "=", "1", "0", "0", ">", "</svg>"]
      result = Dna.read(strand)
      assert expected_result == result
    end
  end

  describe "write_strand/1" do
    test "it writes a strand from an svg string" do
      svg_string = "<svg width=100 height=100></svg>"
      expected_result = "AAAAAEAAHAADAACAACAAFAAHAADAACAACAAGAAB"
      result = Dna.write_strand(svg_string)
      assert result == expected_result
    end
  end

  describe "translate/1" do
    test "it codes an opening SVG tag" do
      expected_result = "<svg"
      result = Dna.translate("AAA")
      assert result == expected_result
    end
    test "it codes a closing SVG tag" do
      expected_result = "</svg>"
      result = Dna.translate("AAB")
      assert result == expected_result
    end
    test "it codes a number 0" do
      expected_result = "0"
      result = Dna.translate("AAC")
      assert result == expected_result
    end
    test "it codes a number 1" do
      expected_result = "1"
      result = Dna.translate("AAD")
      assert result == expected_result
    end
    test "it codes a width attribute" do
      expected_result = "width"
      result = Dna.translate("AAE")
      assert result == expected_result
    end
    test "it codes a height attribute" do
      expected_result = "height"
      result = Dna.translate("AAF")
      assert result == expected_result
    end
    test "it codes a closing angle >" do
      expected_result = ">"
      result = Dna.translate("AAG")
      assert result == expected_result
    end
    test "it codes an = sign" do
      expected_result = "="
      result = Dna.translate("AAH")
      assert result == expected_result
    end
    test "it does not code an unrecognized codon" do
      expected_result = ""
      result = Dna.translate("AAAA")
      assert result == expected_result
    end
  end
end
