defmodule IssApiTest.LocationTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IssApi.Parser.Location

  describe "IssApi.Location.parse/1" do
    property "should generate new locations" do
      check all ts <- positive_integer(),
                long <- float(),
                lat <- float(),
                loc = %{
                  "timestamp" => ts,
                  "iss_position" => %{"latitude" => to_string(lat), "longitude" => to_string(long)}
                } do
        {:ok, %{timestamp: new_ts, position: {new_lat, new_long}}} = Location.parse(loc)
        assert new_ts == ts
        assert_in_delta new_lat, lat, 0.01
        assert_in_delta new_long, long, 0.01
      end
    end

    test "should give error when given invalid arguments" do
      {err, _} = Location.parse("not a number")
      assert err == :error
    end
  end
end
