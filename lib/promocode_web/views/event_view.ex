defmodule PromocodeWeb.EventView do
  use PromocodeWeb, :view
  alias PromocodeWeb.EventView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{id: event.id,
      event_name: event.event_name,
      event_longitude: event.event_longitude,
      event_latitude: event.event_latitude,
      event_worth: event.event_worth,
      is_active: event.is_active,
      expiry_date: event.expiry_date}
  end
end
