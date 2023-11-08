defmodule IssApi.Parser do
  @type json :: String.t()
  @type data :: map()
  @type paths :: list(list(any()))

  @callback parse(json()) :: {:ok, map()} | {:error, {atom(), term()}}

  defmacro __using__(_opts) do
    quote do
      @behaviour IssApi.Parser

      import IssApi.Parser, only: [decode_json: 1, extract_values: 2]
    end
  end

  @spec decode_json(json) :: {:ok, map()} | {:error, {atom(), json}}
  def decode_json(json) do
    case Jason.decode(json) do
      {:ok, data} -> {:ok, data}
      {:error, _} -> {:error, {:invalid_json, json}}
    end
  end

  @spec extract_values(data, paths) :: list(any()) 
  def extract_values(data, paths) do
    Enum.reduce(paths, [], fn path, acc ->
      [get_in(data, path) | acc]
    end)
    |> Enum.reverse()
  end
end
