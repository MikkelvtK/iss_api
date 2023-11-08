defmodule IssApiTest.ClientTest do
  use ExUnit.Case

  import Mox

  @iss_location_url "http://api.open-notify.org/iss-now.json"

  setup :verify_on_exit!

  describe "IssApi.Client.fetch/1" do
    test "should return a map when 200 status is received" do
      expect(HTTPoison.BaseMock, :get, fn args ->
        assert args == @iss_location_url 
        {:ok, %{status_code: 200, body: "{\"test\": \"some body\"}"}}
      end)

      assert {:ok, res} = IssApi.Client.fetch(@iss_location_url)
      assert String.equivalent?(res,"{\"test\": \"some body\"}")
    end

    test "should return an atom when :error is received" do
      expect(HTTPoison.BaseMock, :get, fn args ->
        assert args == @iss_location_url 
        {:error, %{reason: :some_error}} 
      end)

      assert {:error, {:httpoison_error, :some_error}} = IssApi.Client.fetch(@iss_location_url)
    end

    test "should return a string when no 200 is received" do
      expect(HTTPoison.BaseMock, :get, fn args ->
        assert args == @iss_location_url 
        {:ok, %{status_code: 404, body: "not found"}} 
      end)

      assert {:error, {:open_notify_error, _}} = IssApi.Client.fetch(@iss_location_url)
    end
  end
end
