defmodule IssApi.Collector do
  @moduledoc false 

  alias IssApi.Client

  @type parser :: atom()
  @type url :: String.t()

  @spec start(parser(), url()) :: {:ok, IssApi.t()} | {:error, IssApi.error()}
  def start(parser, url) when is_atom(parser) do
    url
    |> Client.fetch()
    |> process(parser)
  end

  defp process({:ok, data}, parser) do
    data
    |> parser.parse()
  end

  defp process(error, _parser), do: error
end
