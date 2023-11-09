defmodule IssApi.Parser do
  @type json :: String.t()
  @type data :: map()

  @callback parse(json()) :: {:ok, map()} | {:error, {atom(), term()}}

  defmacro __using__(_opts) do
    quote do
      @behaviour IssApi.Parser

      import IssApi.Parser, only: [decode_json: 1]
    end
  end

  @spec decode_json(json()) :: {:ok, data()} | {:error, IssApi.error()} 
  def decode_json(json) do
    case Jason.decode(json) do
      {:ok, data} -> {:ok, data}
      {:error, _} -> {:error, {:invalid_json, json}}
    end
  end
end
