defmodule IssApi.Parser.LocationParser do
  use IssApi.Parser

  @type json :: String.t()
  @type unix_epoch :: integer()
  @type latitude :: float()
  @type longitude :: float()
  @type iss_location :: %{timestamp: unix_epoch(), position: {latitude(), longitude()}}

  @impl IssApi.Parser
  @spec parse(json()) :: {:ok, IssApi.Location.t()} | {:error, {:atom, term()}}
  def parse(json) when is_binary(json) do
    with {:ok, data} <- decode_json(json),
         {ts, lat, long} = extract_values(data), 
         {:ok, ts} <- parse_unix_epoch(ts),
         {:ok, lat} <- parse_float(lat),
         {:ok, long} <- parse_float(long) do
      {:ok, Map.new(timestamp: ts, position: {lat, long})}
    end
  end

  def parse(json), do: {:error, {:invalid_argument, json}}

  defp extract_values(data) do
    {
      get_in(data, ["timestamp"]),
      get_in(data, ["iss_position", "latitude"]),
      get_in(data, ["iss_position", "longitude"])
    }
  end

  defp parse_float(val) when is_binary(val) do
    case Float.parse(val) do
      {float, _} -> {:ok, float}
      :error -> {:error, {:invalid_float, val}}
    end
  end

  defp parse_float(val), do: {:error, {:invalid_float, val}}

  defp parse_unix_epoch(val) when is_integer(val), do: {:ok, val}
  defp parse_unix_epoch(val), do: {:error, {:invalid_unix_epoch, val}}
end
