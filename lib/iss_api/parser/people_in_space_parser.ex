defmodule IssApi.Parser.PeopleInSpaceParser do
  @moduledoc false

  use IssApi.Parser
  alias IssApi.PeopleInSpace

  @impl IssApi.Parser
  def parse(json) when is_binary(json) do
    with {:ok, data} <- decode_json(json),
         {:ok, number, people} <- extract_values(data) do
      {:ok,
       %PeopleInSpace{
         number: number,
         people: people
       }}
    end
  end

  defp extract_values(data) do
    with {:ok, number} <-
           Map.get(data, "number") |> parse_number(),

         {:ok, people} <-
           Map.get(data, "people") |> parse_people() do

      {:ok, number, people}
    end
  end

  defp parse_people(data) do
    people =
      for person <- data do
        with {:ok, name} <- Map.fetch(person, "name"),
             {:ok, craft} <- Map.fetch(person, "craft") do
          Map.new(name: name, craft: craft)
        end
      end

    cond do
      :error in people ->
        {:error, {:invalid_person, data}}

      true ->
        {:ok, people}
    end
  end

  defp parse_number(val) when is_integer(val), do: {:ok, val}
  defp parse_number(val), do: {:error, {:invalid_number, val}}
end
