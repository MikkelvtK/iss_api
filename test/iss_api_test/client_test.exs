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

      {:ok, res} = IssApi.Client.fetch(@iss_location_url)
      assert is_map(res) 
    end

    test "should return an atom when :error is received" do
      expect(HTTPoison.BaseMock, :get, fn args ->
        assert args == @iss_location_url 
        {:error, %{reason: :some_error}} 
      end)

      {:error, res} = IssApi.Client.fetch(@iss_location_url)
      assert is_atom(res) 
    end

    test "should return a string when no 200 is received" do
      expect(HTTPoison.BaseMock, :get, fn args ->
        assert args == @iss_location_url 
        {:ok, %{status_code: 404, body: "not found"}} 
      end)

      {:error, res} = IssApi.Client.fetch(@iss_location_url)
      assert is_binary(res) 
    end
  end
end