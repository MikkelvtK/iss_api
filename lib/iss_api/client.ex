defmodule IssApi.Client do
  @moduledoc false

  @env Mix.env()

  @spec fetch(IssApi.Collector.url()) ::
          {:ok, IssApi.Parser.json()} | {:error, IssApi.error()}
  def fetch(url) do
    http_client(@env).get(url)
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %{status_code: _, body: body}}) do
    {:error, {:open_notify_error, body}}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, {:httpoison_error, reason}}
  end

  defp http_client(env) when env == :test do 
    Application.get_env(:iss_api, :http_client)
  end

  defp http_client(_env), do: HTTPoison
end
