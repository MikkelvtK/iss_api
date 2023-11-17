defmodule IssApiTest.Parser.LocationParserTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IssApi.Parser.LocationParser

  describe "IssApi.Parser.LocationParser.parse/1" do
    property "giving correct json returns map" do
      check all ts <- positive_integer(),
                lat <- float(),
                long <- float(),
                json = build_correct_json(ts, to_string(lat), to_string(long)) do
        assert {:ok, %IssApi.Location{}} = LocationParser.parse(json) 
      end  
    end

    property "giving incorrect input gives back error" do
      check all bad_input <- term(),
                not is_binary(bad_input),
                max_runs: 20 do
        assert {:error, {:invalid_json, _}} = LocationParser.parse(bad_input)
      end
    end

    property "bad json gives :invalid_json error" do
      check all json <- string([?a..?z, ?A..?Z]) do
        assert {:error, {:invalid_json, _}} = LocationParser.parse(json)
      end
    end

    property "bad lat and long values give :invalid_float error" do
      check all ts <- positive_integer(),
                lat <- string([?a..?z, ?A..?Z]),
                long <- string([?a..?z, ?A..?Z]),
                json = build_correct_json(ts, lat, long) do
        assert {:error, {:invalid_float, _}} = LocationParser.parse(json)
      end
    end

    property "unexpected lat and long values give :unexpected_float error" do
      check all ts <- positive_integer(),
                lat <- one_of([boolean(), integer(), float()]),
                long <- one_of([boolean(), integer(), float()]),
                json = build_json_with_incorrect_lat_long_value_types(ts, lat, long) do
        assert {:error, {:unexpected_float, _}} = LocationParser.parse(json)
      end
    end

    property "bad timestamps gives :invalid_unix_epoch error" do
      check all ts <- string([?a..?z, ?A..?Z]),
                lat <- float(), 
                long <- float(), 
                ts = "\"#{ts}\"", 
                json = build_correct_json(ts, lat, long) do
        assert {:error, {:invalid_unix_epoch, _}} = LocationParser.parse(json)
      end
    end

    property "values are retrieved from json" do
      check all ts <- positive_integer(),
                lat <- float(),
                long <- float(),
                json = build_correct_json(ts, lat, long) do
        {:ok, %{timestamp: new_ts, position: %{latitude: new_lat, longitude: new_long}}} = 
          LocationParser.parse(json)
        assert new_ts == ts && new_lat == lat && new_long == long
      end
    end

    property "missing keys return errors" do
      check all ts <- string(:ascii),
                lat <- string(:ascii), 
                long <- string(:ascii), 
                json = build_incorrect_json(ts, lat, long) do
        assert {:error, _} = LocationParser.parse(json)
      end
    end
  end

  defp build_correct_json(ts, lat, long) do
    "{\"message\": \"success\", \"iss_position\": {\"latitude\": \"#{lat}\", \"longitude\": \"#{long}\"}, \"timestamp\": #{ts}}"
  end

  defp build_json_with_incorrect_lat_long_value_types(ts, lat, long) do
    "{\"message\": \"success\", \"iss_position\": {\"latitude\": #{lat}, \"longitude\": #{long}}, \"timestamp\": #{ts}}"
  end

  defp build_incorrect_json(ts, lat, long) do
    "{\"message\": \"success\", \"iss_position\": {\"#{lat}\": \"1.0\", \"#{long}\": \"1.0\"}, \"#{ts}\": 1}"
  end
end
