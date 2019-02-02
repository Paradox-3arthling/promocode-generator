defmodule Promocode.EventsPromocode.Event do
  use Ecto.Schema
  import Ecto.Changeset


  schema "events" do
    field :expiry_date, :naive_datetime
    field :event_latitude, :float
    field :event_longitude, :float
    field :event_name, :string
    field :event_worth, :decimal
    field :is_active, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:expiry_date, :event_name, :event_longitude, :event_latitude, :event_worth, :is_active])
    |> validate_required([:expiry_date, :event_name, :event_longitude, :event_latitude, :event_worth, :is_active])
  end
end
