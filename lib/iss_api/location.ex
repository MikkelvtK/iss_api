defmodule IssApi.Location do
  @moduledoc """
  Contains all logic that involves the location of the ISS.
  """

  require Logger

  @type timestamp :: non_neg_integer()
  @type longitude :: float()
  @type latitude :: float()
  @type t :: %__MODULE__{
          timestamp: non_neg_integer(),
          position: {latitude(), longitude()}
        }

  @enforce_keys [:timestamp, :position]
  defstruct [:timestamp, :position]

  @spec new(non_neg_integer(), latitude(), longitude()) ::
          {:ok, __MODULE__.t()} | {:error, String.t()}
  def new(ts, lat, long)
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

  def new(ts, lat, long) do
    Logger.error("invalid arguments given: #{inspect {ts, lat, long}}")
    {
      :error,
      "invalid arguments given to function: #{__MODULE__}.new/3"
    }
  end
end
