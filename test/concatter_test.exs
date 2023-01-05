defmodule ConcatterTest do
  use ExUnit.Case
  doctest Concatter

  test "greets the world" do
    assert Concatter.hello() == :world
  end
end
