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

  @doc """
  This will return the current location of the International Space Station.

  The function will return a tuple. The first value is an atom and will be either 
  `:ok` or `:error`. The second value will be the `IssApi.Location` struct or 
  an error message in the case of an error.

  The `IssApi.Location` has two fields and three values in total. The first field
  is the `timestamp` field. This will return the time in UNIX format. Meaning 
  it will return the amount of seconds that have passed since 1 January 1970.
  The second field is the `position` field. This is a tuple containing to floats,
  the `latitude` and the `longitude`.

  ## Examples

      IssApi.location()
      {:ok, %IssApi.Location{timestamp: 1699027915, position: {35.9648, -143.0953}}}

  """
  @spec location() :: {:ok, IssApi.Location.t()} | {:error, String.t()}
  def location do
    Collector.build()
  end
end
