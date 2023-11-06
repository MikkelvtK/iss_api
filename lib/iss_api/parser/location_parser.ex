defmodule IssApi.Parser.LocationParser do
  use IssApi.Parser

  alias IssApi.Location

  @type json :: String.t()

  @impl IssApi.Parser
  @spec parse(json()) :: {:ok, IssApi.Location.t()} | {:error, String.t()}
  def parse(json) when is_binary(json) do
    case Jason.decode(json) do
      {:ok, data} ->
        ts = get_in(data, ["timestamp"])

        {lat, _} =
          get_in(data, ["iss_position", "latitude"])
          |> Float.parse()

        {long, _} =
          get_in(data, ["iss_position", "longitude"])
          |> Float.parse()

        Location.new(ts, lat, long)

      {:error, _} ->
        error(json)
    end
  end

  def parse(json), do: error(json)
end
