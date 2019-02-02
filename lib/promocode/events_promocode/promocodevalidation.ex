defmodule Promocode.EventsPromocode.Promocodevalidation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "promocodes" do
    # field :promo_code_tag, :string
    field :origin, {:array, :float}
    field :destination, {:array, :float}
    field :radius_in_km, :float
    # field :origin_longitude, :float
    # field :origin_latitude, :float
    # field :destination_longitude, :float
    # field :destination_latitude, :float
  end

  @doc false
  def changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:origin, :destination, :radius_in_km])
    |> validate_required([:origin, :destination, :radius_in_km])
    # |> vaildate_format(:origin, -r/[\d+ ,\d+]/)
    # |> cast(attrs, [:promo_code_tag, :origin_longitude, :origin_latitude, :destination_longitude, :destination_latitude])
    # |> validate_required([:promo_code_tag, :origin_longitude, :origin_latitude, :destination_longitude, :destination_latitude])
  end

end
