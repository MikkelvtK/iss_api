defmodule IssApi.Client do
  @moduledoc false

  @spec fetch(String.t()) :: {:ok, map()} | {:error, atom()} | {:error, String.t()}
  def fetch(url) do
    http_client().get(url)
    |> handle_response
  end

  defp handle_response({:ok, res}) do
    body = Map.get(res, :body)
    case Map.get(res, :status_code) do
      200 -> 
        body |> Jason.decode
      _ -> 
        {:error, body}
    end 
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

  defp http_client do
    Application.get_env(:iss_api, :http_client)
  end
end
