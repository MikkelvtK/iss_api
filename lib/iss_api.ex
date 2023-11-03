defmodule IssApi do
  @moduledoc """
  Documentation for `IssApi`.
  """
  alias IssApi.Collector

  @spec location() :: {:ok, IssApi.Location.t()} | {:error, String.t()}
  def location do
    Collector.build()
  end
end
