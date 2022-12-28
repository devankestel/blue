defmodule Blue.ConceptTest do
    use ExUnit.Case
    alias Blue.Concept

    describe "new/0" do
        test "creates a new avatar" do
            avatar = Concept.new()

            assert avatar.position == {0, 0}
        end
    end
end