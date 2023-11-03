defmodule IssApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :iss_api,
      name: "IssApi",
      version: "0.1.0",
      elixir: "~> 1.15",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/MikkelvtK/iss_api",
      homepage_url: "https://github.com/MikkelvtK/iss_api",
      docs: [
        main: "IssApi",
        extras: ["README.md"]
      ],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "README.md",
        "mix.exs"
      ],
      maintainers: [
        "MikkelvtK"
      ],
      licenses: [
        "Apache-2.0"
      ],
      links: %{
        "GitHub" => "https://github.com/MikkelvtK/iss_api"
      }
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:stream_data, "~> 0.6", only: :test},
      {:mox, "~> 1.0", only: :test},
      {:excoveralls, "~> 0.18.0", only: [:test]}
    ]
  end
end
