defmodule IssApi.Parser.LocationParser do
  use IssApi.Parser

  @impl IssApi.Parser
  @spec parse(IssApi.Parser.json()) ::
          {:ok, IssApi.iss_location()} | {:error, IssApi.error()}
  def parse(json) when is_binary(json) do
    with {:ok, data}            <- decode_json(json),
         {:ok, {ts, lat, long}} <- extract_values(data) do
      {:ok, Map.new(timestamp: ts, position: {lat, long})}
    end
  end

  def parse(json), do: {:error, {:invalid_argument, json}}

  defp extract_values(data) do
    with {:ok, ts} <-
           get_in(data, ["timestamp"])
           |> parse_unix_epoch(),

         {:ok, lat} <-
           get_in(data, ["iss_position", "latitude"])
           |> parse_float(),

         {:ok, long} <-
           get_in(data, ["iss_position", "longitude"])
           |> parse_float() do
      {:ok, {ts, lat, long}}
    end
  end

  defp parse_float(val) when is_binary(val) do
    case Float.parse(val) do
      {float, _} -> {:ok, float}
      :error -> {:error, {:invalid_float, val}}
    end
  end

  defp parse_float(val), do: {:error, {:unexpected_float, val}}

  defp parse_unix_epoch(val) when is_integer(val), do: {:ok, val}
  defp parse_unix_epoch(val), do: {:error, {:invalid_unix_epoch, val}}
end
