defmodule Mix.Tasks.Concatter do
  @moduledoc "Pass a directory and an extension to concatenate all files in that directory and its subdirectories."
  use Mix.Task

  @shortdoc "Pass a directory and an extension to concatenate all files in that directory and its subdirectories."
  def run([path, ext]) do
    Mix.Task.run("compile")

    Concatter.concat_files(path, ext)
    |> IO.inspect()
  end
end
