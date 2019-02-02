defmodule PromocodeWeb.EventControllerTest do
  use PromocodeWeb.ConnCase

  alias Promocode.EventsPromocode
  alias Promocode.EventsPromocode.Event

  @create_attrs %{
    event_latitude: 120.5,
    event_longitude: 120.5,
    expiry_date: "2019-02-14 00:00:00",
    event_name: "some event_name",
    event_worth: "120.5",
    is_active: true
  }
  @update_attrs %{
    event_latitude: 456.7,
    event_longitude: 456.7,
    expiry_date: "2019-02-14 00:00:00",
    event_name: "some updated event_name",
    event_worth: "456.7",
    is_active: false
  }
  @invalid_attrs %{event_latitude: nil, event_longitude: nil, event_name: nil, event_worth: nil, is_active: nil, expiry_date: nil}

  def fixture(:event) do
    {:ok, event} = EventsPromocode.create_event(@create_attrs)
    event
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => id,
               "event_latitude" => 120.5,
               "event_longitude" => 120.5,
               "event_name" => "some event_name",
               "event_worth" => "121",
               "is_active" => true
             } = json_response(conn, 200)["data"]
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
    #   assert json_response(conn, 400)["errors"] != %{}
    # end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => id,
               "event_latitude" => 456.7,
               "event_longitude" => 456.7,
               "event_name" => "some updated event_name",
               "event_worth" => "457",
               "is_active" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
