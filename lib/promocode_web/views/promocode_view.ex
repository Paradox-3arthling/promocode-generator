defmodule PromocodeWeb.PromocodeView do
  use PromocodeWeb, :view
  alias PromocodeWeb.PromocodeView

  def render("index.json", %{promocodes: promocodes}) do
    %{data: render_many(promocodes, PromocodeView, "promocode.json")}
  end

  def render("show.json", %{promocode: promocode}) do
    %{data: render_one(promocode, PromocodeView, "promocode.json")}
  end

  def render("promocode.json", %{promocode: promocode}) do
    %{id: promocode.id,
      promo_code_tag: promocode.promo_code_tag,
      is_active: promocode.is_active,
      in_use: promocode.in_use,
      expiry_datetime: promocode.event.expiry_date,
      promo_code_worth: promocode.promo_code_worth,
      event_name: promocode.event.event_name,
      event_longitude: promocode.event.event_longitude,
      event_latitude: promocode.event.event_latitude}
  end
end
