defmodule IssApiTest.Parser.LocationParserTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IssApi.Parser.LocationParser

  describe "IssApi.Parser.LocationParser/1" do
    property "giving correct json returns IssApi.Location struct" do
      check all ts <- positive_integer(),
                lat <- float(),
                long <- float(),
                json = build_correct_json(ts, lat, long) do
        assert {:ok, %IssApi.Location{}} = LocationParser.parse(json) 
      end  
    end

    property "giving incorrect input gives back error" do
      check all bad_input <- term(),
                max_runs: 20 do
        assert {:error, _} = LocationParser.parse(bad_input)
      end
    end

    property "values are retrieved from json" do
      check all ts <- positive_integer(),
                lat <- float(),
                long <- float(),
                json = build_correct_json(ts, lat, long) do
        {:ok, %{timestamp: new_ts, position: {new_lat, new_long}}} = LocationParser.parse(json)
        assert new_ts == ts && new_lat == lat && new_long == long
      end
    end
  end

  defp build_correct_json(ts, lat, long) do
    "{\"message\": \"success\", \"iss_position\": {\"latitude\": \"#{lat}\", \"longitude\": \"#{long}\"}, \"timestamp\": #{ts}}"
  end
end
