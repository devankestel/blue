defmodule Blue.ProtagonistTest do
    use ExUnit.Case
    alias Blue.Protagonist
    describe "new/0" do
        test "creates protagonist" do
            protagonist = Protagonist.new()

            protagonist.sprite.color == :black
            protagonist.step_count == 0
        end
    end
end