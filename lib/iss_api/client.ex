defmodule IssApi.Client do
  @moduledoc false

  @spec fetch(String.t()) :: {:ok, map()} | {:error, {atom(), term()}} 
  def fetch(url) do
    http_client().get(url)
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

  defp http_client do
    httpoison = Application.get_env(:iss_api, :http_client)
    if httpoison == nil do
      Application.put_env(:iss_api, :http_client, HTTPoison)
    end

    Application.get_env(:iss_api, :http_client)
  end
end
