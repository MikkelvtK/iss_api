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

      assert {:ok, %{timestamp: ts, position: %{latitude: lat, longitude: long}}} = IssApi.location()
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

      assert {:error, {:open_notify_error, _}} = IssApi.location()
    end
  end

  describe "IssApi.location!/0" do
    test "should return location struct on success" do
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
      
      assert %IssApi.Location{} = IssApi.location!()
    end

    test "should raise error on failure" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 404,
            body: "not found"
          }
        }
      end)
     
      assert_raise IssApi.Error, fn -> IssApi.location!() end 
    end
  end

  describe "IssApi.people_in_space/0" do
    test "should return :ok on success" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 200,
            body:
              "{\"number\": 1, \"people\": [{\"name\": \"test\", \"craft\": \"test\"}]}"
          }
        }
      end)
      
      assert {:ok, _} = IssApi.people_in_space()
    end

    test "should return :error on failure" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 404,
            body: "not found"
          }
        }
      end)

      assert {:error, _} = IssApi.people_in_space()
    end
  end

  describe "IssApi.people_in_space!/0" do
    test "should return response on success" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 200,
            body:
              "{\"number\": 1, \"people\": [{\"name\": \"test\", \"craft\": \"test\"}]}"
          }
        }
      end)
      
      assert %IssApi.PeopleInSpace{} = IssApi.people_in_space!()
    end

    test "should raise error on failure" do
      expect(HTTPoison.BaseMock, :get, fn _args ->
        {
          :ok,
          %{
            status_code: 404,
            body: "not found"
          }
        }
      end)
      
      assert_raise IssApi.Error, fn -> IssApi.people_in_space!() end
    end
  end
end
