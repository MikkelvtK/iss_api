# IssApi

![Elixir CI](https://github.com/MikkelvtK/iss_api/actions/workflows/elixir.yml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/MikkelvtK/iss_api/badge.svg?branch=main)](https://coveralls.io/github/MikkelvtK/iss_api?branch=main) ![Hex.pm](https://img.shields.io/hexpm/v/iss_api)
<br>
IssApi is a wrapper written in Elixir for [Open Notify](http://open-notify.org).

Library documentation can be found on [Hex Docs](https://hexdocs.pm/iss_api)

## Installation

To use the library add the `IssApi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iss_api, "~> 0.1.2"}
  ]
end
```
## Usage

To invoke the library function you can use this code snippet:

```elixir
iex> IssApi.location()
{:ok, %IssApi.Location{timestamp: 1699027915, position: {35.9648, -143.0953}}}
```

