# IssApi

![Elixir CI](https://github.com/MikkelvtK/iss_api/actions/workflows/elixir.yml/badge.svg) [![Coverage Status](https://coveralls.io/repos/github/MikkelvtK/iss_api/badge.svg?branch=main)](https://coveralls.io/github/MikkelvtK/iss_api?branch=main) ![Hex.pm](https://img.shields.io/hexpm/v/iss_api)
<br>

## Description

IssApi is a wrapper written in Elixir for [Open Notify](http://open-notify.org). It provides a way to tap in to
some of NASA's data via an API interface. It currently supports two different endpoints:

* [Current location of the ISS](http://open-notify.org/Open-Notify-API/ISS-Location-Now/)
* [Number of people in space](http://open-notify.org/Open-Notify-API/People-In-Space/)

As of now the wrapper only supports the current location of the ISS, but will add the second endpoint 
at some point.

### Current Location of the ISS

The current location of the ISS is provided by the Open notify API in the following format:

```JSON
{
  "message": "success", 
  "timestamp": UNIX_TIME_STAMP, 
  "iss_position": {
    "latitude": CURRENT_LATITUDE, 
    "longitude": CURRENT_LONGITUDE
  }
}
```

The `UNIX_TIME_STAMP` is of type integer and will be parsed directly by the wrapper. The `CURRENT_LATITUDE` 
and `CURRENT_LONGITUDE` are of type float, but are presented as strings in the API. The `IssApi` wrapper will
parse these values to float directly so they can be directly used in the code without having to do anything
extra.

An example of what that would look like:

```elixir
iex> IssApi.location()
{:ok, %{position: {35.9648, -143.0953}, timestamp: 1699027915}}
```

As shown above, the function will return a tuple where the first element will be either `:ok` or `:error` and the second
element will be the response. In case of `:ok`, the response will be a map with two keys. The first one is `position`, 
which will have a value that is a tuple. The first value of the tuple is the latitude and the second element is
the longitude. The second key is the `timestamp`. When an `:error` is returned, it will always return a tuple where 
the second element is another tuple with the error code and the value that caused the error.

## Installation

To use the library add the `IssApi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:iss_api, "~> 0.2.0"}
  ]
end
```

