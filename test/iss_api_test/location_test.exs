defmodule IssApiTest.LocationTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IssApi.Location

  describe "IssApi.Location.new/2" do
    property "should generate new locations" do
      check all ts <- positive_integer(),
                long <- float(),
                lat <- float(),
                loc = Location.new(ts, {long, lat}) do 
        %Location{timestamp: new_ts, position: {new_long, new_lat}} = loc
        assert new_ts == ts
        assert_in_delta new_lat, lat, 0.01 
        assert_in_delta new_long, long, 0.01
      end
    end

    test "should give error when given invalid arguments" do
      {err, _} = Location.new("not a number", 15)
      assert err == :error
    end
  end
end
