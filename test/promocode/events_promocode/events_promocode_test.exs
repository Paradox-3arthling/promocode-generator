defmodule Promocode.EventsPromocodeTest do
  use Promocode.DataCase

  alias Promocode.EventsPromocode

  describe "events" do
    alias Promocode.EventsPromocode.Event

    @valid_attrs %{event_latitude: 120.5, event_longitude: 120.5, event_name: "some event_name", event_worth: "121", is_active: true, expiry_date: "2019-02-14 00:00:00"}
    @update_attrs %{event_latitude: 456.7, event_longitude: 456.7, event_name: "some updated event_name", event_worth: "456.7", is_active: false, expiry_date: "2019-02-14 00:00:00"}
    @invalid_attrs %{event_latitude: nil, event_longitude: nil, event_name: nil, event_worth: nil, is_active: nil, expiry_date: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EventsPromocode.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert EventsPromocode.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert EventsPromocode.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = EventsPromocode.create_event(@valid_attrs)
      assert event.event_latitude == 120.5
      assert event.event_longitude == 120.5
      assert event.event_name == "some event_name"
      assert event.event_worth == Decimal.new("121")
      assert event.is_active == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventsPromocode.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = EventsPromocode.update_event(event, @update_attrs)
      assert event.event_latitude == 456.7
      assert event.event_longitude == 456.7
      assert event.event_name == "some updated event_name"
      assert event.event_worth == Decimal.new("456.7")
      assert event.is_active == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = EventsPromocode.update_event(event, @invalid_attrs)
      assert event == EventsPromocode.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = EventsPromocode.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> EventsPromocode.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = EventsPromocode.change_event(event)
    end
  end

  describe "promocodes" do
    # alias Promocode.EventsPromocode.Promocode


    @valid_attrs %{is_active: false, in_use: true, promo_code_worth: "1245"}
    # @update_attrs %{is_active: false, promo_code_tag: "some updated promo_code_tag", promo_code_worth: "456.7"}
    @invalid_attrs %{event_id: nil, is_active: nil, promo_code_tag: nil, promo_code_worth: nil}

    def promocode_fixture(attrs \\ %{}) do
      event = event_fixture()
      valid_attr = Map.put(@valid_attrs, :event_id, event.id)
      {:ok, promocode} =
        attrs
        |> Enum.into(valid_attr)
        |> EventsPromocode.create_promocode()

      promocode
    end

    test "list_promocodes/0 returns all promocodes" do
      promocode = promocode_fixture()
      assert EventsPromocode.list_promocodes() == [promocode]
    end

    # test "get_promocode!/1 returns the promocode with given id" do
    #   promocode = promocode_fixture()
    #   assert EventsPromocode.get_promocode!(promocode.id) == promocode
    # end

    test "create_promocode/1 with valid data creates a promocode" do
      promocode = promocode_fixture()
      assert promocode.is_active == false
      assert promocode.in_use == true
      assert promocode.promo_code_worth == Decimal.new("1245")
    end

    test "create_promocode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventsPromocode.create_promocode(@invalid_attrs)
    end

    # test "update_promocode/2 with valid data updates the promocode" do
    #   promocode = promocode_fixture()
    #   assert {:ok, %Promocode{} = promocode} = EventsPromocode.update_promocode(promocode, @update_attrs)
    #   assert promocode.is_active == false
    #   assert promocode.promo_code_tag == "some updated promo_code_tag"
    #   assert promocode.promo_code_worth == Decimal.new("456.7")
    # end

    test "update_promocode/2 with invalid data returns error changeset" do
      promocode = promocode_fixture()
      assert {:error, %Ecto.Changeset{}} = EventsPromocode.update_promocode(promocode, @invalid_attrs)
      assert promocode == EventsPromocode.get_promocode(promocode.id)
    end

    # test "delete_promocode/1 deletes the promocode" do
    #   promocode = promocode_fixture()
    #   assert {:ok, %Promocode{}} = EventsPromocode.delete_promocode(promocode)
    #   assert_raise Ecto.NoResultsError, fn -> EventsPromocode.get_promocode!(promocode.id) end
    # end

    # test "change_promocode/1 returns a promocode changeset" do
    #   promocode = promocode_fixture()
    #   assert %Ecto.Changeset{} = EventsPromocode.change_promocode(promocode)
    # end
  end
end
