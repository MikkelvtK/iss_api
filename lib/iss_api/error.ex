defmodule IssApi.Error do
  defexception [:message]
 
  @impl true
  def exception(val) do
    msg = format(val)
    %IssApi.Error{message: msg}
  end

  defp format({code, val}) do
    msg = code |> Atom.to_string() |> String.replace("_", " ")
    "received #{msg}: #{inspect(val)}"
  end
end
