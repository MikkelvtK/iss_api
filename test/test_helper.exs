Mox.defmock(HTTPoison.BaseMock, for: HTTPoison.Base)
Application.put_env(:iss_api, :http_client, HTTPoison.BaseMock)

ExUnit.start()
