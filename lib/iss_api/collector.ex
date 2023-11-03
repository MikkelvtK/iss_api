defmodule IssApi.Collector do
  alias IssApi.Client
  alias IssApi.Location

  @spec build() :: {:ok, Location.t()} | {:error, String.t()}
  def build do
    url()
    |> Client.fetch
    |> extract
    |> _build
  end

  defp _build({:ok, {ts, lat, long}}) do
    Location.new(ts, {lat, long}) 
  end

  defp _build(err), do: err

  defp extract({:ok, res}) do
    {:ok,
      {
        Map.get(res, "timestamp"),
        get_in(res, ["iss_position", "latitude"]),
        get_in(res, ["iss_position", "longitude"]),
      }
    }
  end

  defp extract({:error, msg}) when is_binary(msg) do
    {:error, msg}
  end

  defp extract({:error, code}) do
    {
      :error,
      "httpoison error code: #{code}"
    } 
  end

  defp url do
    Application.get_env(:iss_api, :url)
  end
end
