defmodule IssApi.Collector do
  @moduledoc """
  The `IssApi.Collector` is responsible for gathering all of the information and sending it back to the user.

  The API of the `IssApi.Collector` is very simple. TODO: Explain how the interface starts the Collector. 

  The `IssApi.Collector` does very little of the heavy lifting itself. It's responsibility lies in initiating 
  all necessary modules that are required to give the appropriate response. It will fetch the response from the 
  `IssApi.Client` and then initiate `IssApi.Parser` module given to him as an argument. The result of that will 
  be the response that the user gets back.
  """
  alias IssApi.Client

  @type parser :: atom()
  @type url :: String.t()

  @doc false
  @spec start(parser(), url()) :: {:ok, IssApi.iss_location()} | {:error, IssApi.error()}
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
