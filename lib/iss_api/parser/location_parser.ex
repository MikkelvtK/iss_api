defmodule IssApi.Parser.LocationParser do
  alias IssApi.Location

  @behaviour IssApi.Parser

  @type json :: String.t()

  @impl IssApi.Parser
  @spec parse(json()) :: {:ok, IssApi.Location.t()} | {:error, String.t()}
  def parse(json) when is_binary(json) do
    {:ok, data} = Jason.decode(json)

    ts = get_in(data, ["timestamp"])

    {lat, _} =
      get_in(data, ["iss_position", "latitude"])
      |> Float.parse()

    {long, _} =
      get_in(data, ["iss_position", "longitude"])
      |> Float.parse()

    Location.new(ts, lat, long)
  end

  def parse(data) do
    {
      :error,
      """
      invalid argument.

      expected:
        data :: map()

      got:
        # 1 #{data}
      """
    } 
  end

  @impl IssApi.Parser
  def url do
    "http://api.open-notify.org/iss-now.json"
  end
end
