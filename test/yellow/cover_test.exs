defmodule Yellow.CoverTest do
  use ExUnit.Case

  alias Yellow.Cover
  describe "generate/1" do
    test "it creates a new test file on the appropriate path" do
      module_name = "Macaroni.Cheese"

      expected_path = "test/macaroni/cheese.exs"

      Cover.generate(module_name)

      result_file = File.read(expected_path)

      assert result_file == {:ok, ""}
    end
  end
end
