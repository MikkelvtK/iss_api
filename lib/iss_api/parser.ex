defmodule IssApi.Parser do
  @callback url() :: String.t()
  @callback parse(map()) :: {:ok, term()} | {:error, String.t()}
end
