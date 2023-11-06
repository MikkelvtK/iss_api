defmodule IssApiTest.LocationTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IssApi.Location

  describe "IssApi.Location.parse/1" do
    property "should generate new locations" do
      check all ts <- positive_integer(),
                long <- float(),
                lat <- float() do
        {:ok, %{timestamp: new_ts, position: {new_lat, new_long}}} = Location.new(ts, lat, long)
        assert new_ts == ts
        assert_in_delta new_lat, lat, 0.01
        assert_in_delta new_long, long, 0.01
      end
    end

    test "should give error when given invalid arguments" do
      {err, _} = Location.new("not a number", 42, [])
      assert err == :error
    end
  end
end
