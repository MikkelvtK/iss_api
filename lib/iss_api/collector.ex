defmodule IssApi.Collector do
  @moduledoc false

  alias IssApi.Client
  alias IssApi.Location

  @spec build() :: {:ok, Location.t()} | {:error, String.t()}
  def build do
    url()
    |> Client.fetch()
    |> extract()
    |> _build()
  end

  defp _build({:ok, {ts, lat, long}}) do
    Location.new(ts, {lat, long})
  end

  defp _build(err), do: err

  defp extract({:ok, res}) do
    ts = Map.get(res, "timestamp")

    {lat, _} =
      get_in(res, ["iss_position", "latitude"])
      |> Float.parse()

    {long, _} =
      get_in(res, ["iss_position", "longitude"])
      |> Float.parse()

    {:ok, {ts, lat, long}}
  end

  defp extract({:error, msg}) when is_binary(msg) do
    {:error, msg}
  end

  defp extract({:error, code}) when is_atom(code) do
    {
      :error,
      "httpoison error code: #{code}"
    }
  end

  defp url do
    Application.get_env(:iss_api, :url)
  end
end
