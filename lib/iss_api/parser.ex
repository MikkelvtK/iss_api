defmodule IssApi.Parser do
  require Logger
  @type json :: String.t()

  @callback parse(json()) :: {:ok, term()} | {:error, String.t()}
  @callback error(any()) :: {:error, String.t()}

  defmacro __using__(_opts) do
    quote do
      require Logger 

      @behaviour IssApi.Parser

      def error(input) do
        Logger.error("invalid arguments given: #{inspect input}")
        {
          :error,
          "invalid arguments given to function: #{__MODULE__}"
        }
      end

      defoverridable error: 1
    end
  end
end
