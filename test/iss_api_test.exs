defmodule IssApiTest do
  use ExUnit.Case
  doctest IssApi

  import Mox

  setup :verify_on_exit!

  describe "IssApp.location/0" do
    test "should transform api response to struct" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 200,
            body:
              "{\"timestamp\": 1, \"iss_position\": {\"latitude\": \"-1.0\", \"longitude\": \"2.1\"}}"
          }
        }
      end)

      assert {:ok, %{timestamp: ts, position: {lat, long}}} = IssApi.location()
      assert ts == 1
      assert lat == -1.0
      assert long == 2.1
    end

    test "should return error on non 200 code" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 404,
            body: "not found"
          }
        }
      end)

      assert {:error, msg} = IssApi.location()
      assert String.equivalent?(msg, "not found")
    end
  end
end
