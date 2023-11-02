defmodule IssApi.Location do
  @moduledoc false

  @type longitude :: float()
  @type latitude :: float()
  @type t :: %__MODULE__{timestamp: non_neg_integer(), position: {longitude(), latitude()}}

  @enforce_keys [:timestamp, :position]
  defstruct [:timestamp, :position]

  @spec new(non_neg_integer(), {longitude(), latitude()}) :: t() | {:error, String.t()}
  def new(timestamp, {longitude, latitude})
      when is_integer(timestamp) and timestamp > 0 and is_float(longitude) and is_float(latitude) do
    %__MODULE__{
      timestamp: timestamp,
      position: {longitude, latitude}
    }
  end

  def new(_timestamp, _position), do: {:error, "invalid arguments"}
end
