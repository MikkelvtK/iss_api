defmodule IssApi do
  @moduledoc """
  The `IssApi` is a simple library that functions as a wrapper for the Open Notify
  API.

  The wrapper currently supports one of the two endpoints, which is the current
  location of the International Space Station. It fetches the data returned from
  the API, parses the JSON to a map and then transforms it to a struct before passing
  it to the caller.

  The API has two dependencies that is uses for providing all the functionality to the
  caller:

  * HTTPoison: This is used to make GET requests to the Open Notify API
  * Jason: This is used to parse the JSON returned to a map

  Credits for the API go to it's creators and full details on it can be found on 
  [Open Notify](http://open-notify.org).
  """
  alias IssApi.Collector
  alias IssApi.Parser

  @type error :: {atom(), {atom(), term()}}
  @type unix_epoch :: integer()
  @type latitude :: float()
  @type longitude :: float()
  @type t :: %IssApi.Location{
    timestamp: unix_epoch(), 
    position: %{latitude: latitude(), longitude: longitude()}
  }

  @location_url "http://api.open-notify.org/iss-now.json"

  @doc """
  This will return the current location of the International Space Station.

  The function will return a tuple. The first value is an atom and will be either 
  `:ok` or `:error`. The second value will be a map with the following structure: 

  ```
  @type iss_location :: %{timestamp: unix_epoch(), position: {latitude(), longitude()}}
  ```

  When an `:error` is returned, it will have another tuple as the second element. The tuple
  will contain an error code and the value that caused the error.

  The response has two fields and three values in total. The first field
  is the `timestamp` field. This will return the time in UNIX format. Meaning 
  it will return the amount of seconds that have passed since 1 January 1970.
  The second field is the `position` field. This is a tuple containing to floats,
  the `latitude` and the `longitude`.

  ## Examples

      IssApi.location()
      {:ok, %IssApi.Location{
        timestamp: 1699027915, 
        position: %{latitude: 35.9648, longitude: -143.0953}
      }}

  """
  @spec location() :: {:ok, t()} | error() 
  def location do
    Collector.start(Parser.LocationParser, @location_url)
  end

  @doc """
  The unsafe version of `location` function.

  This function will just return the response and raise an error when an error is received.
  It is not recommended to use this version, but it might be nice for testing purposes.

  ## Examples

      IssApi.location!()
      %IssApi.Location{
        timestamp: 1699027915,
        possition: %{latitude: 35.9648, longitude: -143.0953}
      }

  """
  @spec location!() :: t()
  def location! do
    case Collector.start(Parser.LocationParser, @location_url) do
      {:ok, result}   -> result
      {:error, error} -> raise IssApi.Error, error
    end
  end

  defmodule Location do
    defstruct [:timestamp, :position]
  end
end
