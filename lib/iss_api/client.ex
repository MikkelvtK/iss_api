defmodule IssApi.Client do
  @moduledoc false

  @spec fetch(String.t()) :: {:ok, map()} | {:error, atom() | String.t()}
  def fetch(url) do
    http_client().get(url)
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Jason.decode(body)
  end

  defp handle_response({:ok, %{status_code: _, body: body}}) do
    {:error, body}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

  defp http_client do
    Application.get_env(:iss_api, :http_client)
  end
end
