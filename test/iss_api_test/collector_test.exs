defmodule IssApiTest.CollectorTest do
  use ExUnit.Case

  import Mox

  setup :verify_on_exit!

  describe "IssApi.Collector.init/1" do
    test "should transform api response to struct" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 200,
            body:
              "{\"timestamp\": 1699013111, \"iss_position\": {\"latitude\": \"-49.1182\", \"longitude\": \"20.8571\"}}"
          }
        }
      end)

      assert {:ok, %{timestamp: ts, position: {lat, long}}} = IssApi.Collector.init(IssApi.Parser.Location)
      assert ts == 1_699_013_111
      assert lat == -49.1182
      assert long == 20.8571
    end
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

    assert {:error, msg} = IssApi.Collector.init(IssApi.Parser.Location)
    assert String.equivalent?(msg, "not found")
  end

  test "should return httpoison error code when invalid" do
    expect(HTTPoison.BaseMock, :get, fn _args ->
      {
        :error,
        %{reason: :nxdomain}
      }
    end)
    
    assert {:error, msg} = IssApi.Collector.init(IssApi.Parser.Location)
    assert String.equivalent?(msg, "httpoison error code: nxdomain")
  end
end
