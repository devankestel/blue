defmodule Yellow.Cover do
  def generate(module_name) do
    path_enum = String.split(module_name, ".")
    dir = Enum.at(path_enum, 0)
    file_name = Enum.at(path_enum, 1)
    File.mkdir("test/#{dir}")
    path = "test/#{dir}/#{file_name}.exs"
    File.write(path, "")
  end
end
