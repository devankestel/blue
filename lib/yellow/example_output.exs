defmodule MyDirectory.MyModuleTest do
  use ExUnit.Case
  # should be preserved
  use MyOtherMacro.Stuff
  alias MyDirectory.MyModule
  # should be preserved
  alias MyOtherDirectory.MyOtherModule

  # This code should be preserved
  describe "my_already_tested_mehod/2" do
    test "my_already_written_test" do
      arg1 = "my implemented arg"
      arg2 = "my other implemented arg"
      expected_result = "my expected result"

      result = MyModule.my_already_tested_method(arg1, arg2)

      assert result == expected_result
    end
  end

  describe "my_untested_method/1" do
  end

  describe "my_other_untested_method/3" do
  end
end

# when auto_fail=true
defmodule MyDirectory.MyModuleTest do
  use ExUnit.Case
  # should be preserved
  use MyOtherMacro.Stuff
  alias MyDirectory.MyModule
  # should be preserved
  alias MyOtherDirectory.MyOtherModule

  # This code should be preserved
  describe "my_already_tested_mehod/2" do
    test "my_already_written_test" do
      arg1 = "my implemented arg"
      arg2 = "my other implemented arg"
      expected_result = "my expected result"

      result = MyModule.my_already_tested_method(arg1, arg2)

      assert result == expected_result
    end
  end

  describe "my_untested_method/1" do
    test "auto_fail" do
      arg1 = "Set this arg!"
      expected_result = "Implement this test!"
      result = Mymodule.my_untested_method(arg1)
      assert false
    end
  end

  describe "my_other_untested_method/3" do
    test "auto_fail" do
      arg1 = "Set this arg!"
      arg2 = "Set this arg!"
      arg3 = "Set this arg!"
      expected_result = "Implement this test!"
      result = MyModule.my_other_untested_method(arg1, arg2, arg3)
      assert result == expected_result
    end
  end
end
