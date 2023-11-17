defmodule IssApiTest.Parser.PeopleInSpaceParserTest do
  use ExUnit.Case
  use ExUnitProperties

  alias IssApi.Parser.PeopleInSpaceParser

  defp build_people_json_string(data) do
    Enum.reduce(data, "", fn {name, craft}, acc ->
      acc <> ", {\"name\": \"#{name}\", \"craft\": \"#{craft}\"}"
    end)
  end

  defp build_correct_json(num, data) do
    people = build_people_json_string(data) |> String.trim_leading(", ")
    "{\"number\": #{num}, \"people\": [#{people}]}"
  end
  
  defp build_incorrect_json(num, people) do
    "{\"number\": #{num}, \"people\": #{people}}"
  end

  describe "IssApi.Parser.PeopleInSpaceParser.parse/1" do
    property "should preserve people in response" do
      check all num <- positive_integer(),
                data <- list_of(tuple({string([?a..?z, ?A..?Z]), string([?a..?z, ?A..?Z])}), length: num) do
        json = build_correct_json(num, data)
        assert {:ok, %{number: num, people: people}} = PeopleInSpaceParser.parse(json)
        assert length(people) == num
      end
    end

    test "should return :invalid_person when keys not found" do
      json = build_incorrect_json(1, "[{\"test\": 1, \"test2\": 2}]")
      assert {:error, {:invalid_person, _}} = PeopleInSpaceParser.parse(json)
    end

    test "should return :invalid_people when not given a list" do
      json = build_incorrect_json(1, "\"test\"")
      assert {:error, {:invalid_people, _}} = PeopleInSpaceParser.parse(json)
    end

    test "should return :invalid_number when no number was not found" do
      json = build_incorrect_json(1.0, "\"test\"")
      assert {:error, {:invalid_number, _}} = PeopleInSpaceParser.parse(json)
    end
  end
end
