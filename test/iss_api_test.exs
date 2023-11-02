defmodule IssApiTest do
  use ExUnit.Case
  doctest IssApi

  test "greets the world" do
    assert IssApi.hello() == :world
  end
end
