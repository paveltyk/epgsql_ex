defmodule EpgsqlExTest do
  use ExUnit.Case
  doctest EpgsqlEx

  test "greets the world" do
    assert EpgsqlEx.hello() == :world
  end
end
