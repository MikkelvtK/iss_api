defmodule IssApi.Collector do
  @moduledoc false

  alias IssApi.Client

  @type parser :: atom()

  @spec start(parser(), String.t()) :: {:ok, IssApi.Location.t()} | {:error, String.t()}
  def start(parser, url) when is_atom(parser) do
    url
    |> Client.fetch()
    |> process(parser)
  end

  defp process({:ok, data}, parser) do
    data
    |> parser.parse()
  end

  defp process({:error, msg}, _parser) when is_binary(msg) do
    {:error, msg}
  end

  defp process({:error, code}, _parser) when is_atom(code) do
    {
      :error,
      "httpoison error code: #{code}"
    }
  end
end
