defmodule IssApi.Parser do
  @type json :: String.t()

  @callback parse(json()) :: {:ok, term()} | {:error, String.t()}
end
