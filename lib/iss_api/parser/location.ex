defmodule IssApi.Parser.Location do
  @moduledoc """
  Contains all logic that involves the location of the ISS.
  """

  @type timestamp :: non_neg_integer()
  @type longitude :: float()
  @type latitude :: float()
  @type t :: %__MODULE__{
          timestamp: non_neg_integer(),
          position: {latitude(), longitude()}
        }

  @enforce_keys [:timestamp, :position]
  defstruct [:timestamp, :position]

  @behaviour IssApi.Parser

  @impl IssApi.Parser
  def parse(data) when is_map(data) do
    ts = get_in(data, ["timestamp"])

    {lat, _} =
      get_in(data, ["iss_position", "latitude"])
      |> Float.parse()

    {long, _} =
      get_in(data, ["iss_position", "longitude"])
      |> Float.parse()

    new(ts, lat, long)
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

  @doc false
  @spec new(non_neg_integer(), latitude(), longitude()) ::
          {:ok, __MODULE__.t()} | {:error, String.t()}
  defp new(ts, lat, long)
       when is_integer(ts) and
              ts > 0 and
              is_float(long) and
              is_float(lat) do
    {
      :ok,
      %__MODULE__{
        timestamp: ts,
        position: {lat, long}
      }
    }
  end

  defp new(ts, lat, long) do
    {
      :error,
      """
      invalid arguments.

      expected: 
        timestamp :: non_neg_integer()
        latitude :: float()
        longitude :: float()

      got:
        # 1 #{ts}
        # 2 #{lat}
        # 3 #{long} 
      """
    }
  end
end
