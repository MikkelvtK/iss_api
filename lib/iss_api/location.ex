defmodule IssApi.Location do
  @type longitude :: float()
  @type latitude :: float()
  @type position :: {latitude(), longitude()}
  @type t :: %__MODULE__{
          timestamp: non_neg_integer(),
          position: {latitude(), longitude()}
        }

  @enforce_keys [:timestamp, :position]
  defstruct [:timestamp, :position]

  @doc false
  @spec new(non_neg_integer(), position()) :: t() | {:error, String.t()}
  def new(timestamp, {latitude, longitude})
      when is_integer(timestamp) 
        and timestamp > 0 
        and is_float(longitude) 
        and is_float(latitude) do
    {
      :ok, 
      %__MODULE__{
        timestamp: timestamp,
        position: {latitude, longitude}
      }
    }
  end

  def new(timestamp, position) do
    {
      :error,
      """
      invalid arguments.

      expected: 
        timestamp :: non_neg_integer()
        position :: {float(), float()}

      got:
        1 # #{timestamp}
        2 # #{position}
      """
    }
  end
end
