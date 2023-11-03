import Config

config :iss_api,
  http_client: HTTPoison,
  url: "http://api.open-notify.org/iss-now.json"
