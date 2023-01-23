defmodule Blue.StateTest do
  use ExUnit.Case
  alias Blue.State

  describe "new/0" do
    test "creates a new state" do
      state = State.new()

      assert state.canvas.grid_size == 20
      assert state.canvas.width == 200
      assert state.canvas.height == 400
      assert state.canvas.sprites == []
    end
  end
end
