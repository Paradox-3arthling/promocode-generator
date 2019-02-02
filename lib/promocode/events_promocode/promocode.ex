defmodule Promocode.EventsPromocode.Promocode do
  use Ecto.Schema
  import Ecto.Changeset
  alias Promocode.EventsPromocode.Event


  schema "promocodes" do
    field :is_active, :boolean, default: true
    field :in_use, :boolean, default: false
    field :promo_code_tag, :string
    field :promo_code_worth, :decimal
    belongs_to :event, Event
    # field :event_id, :id

    timestamps()
  end

  @doc false
  def changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:promo_code_tag, :is_active, :promo_code_worth, :event_id, :in_use])
    |> validate_required([:promo_code_tag, :is_active, :promo_code_worth, :event_id, :in_use])
    |> unique_constraint(:promo_code_tag)
    |> foreign_key_constraint(:event_id)
  end

  @doc false
  def is_active_Changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:is_active])
    |> validate_required([:is_active])
  end

  @doc false
  def promocode_Changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:promo_code_tag, :is_active, :promo_code_worth, :event_id, :in_use])
    |> validate_required([:is_active, :promo_code_worth, :event_id, :in_use])
    |> promocode_generator
  end

  defp promocode_generator(%Ecto.Changeset{valid?: true} = changeset) do
  # defp promocode_generator(%Ecto.Changeset{valid?: true, changes: %{promo_code_tag: promo_code_tag}} = changeset) do
    a = :rand.uniform 4200
    b = :rand.uniform 4200
    c = :rand.uniform 4200
    d = :os.system_time(:milli_seconds)
    e = :rand.uniform 4200
    f = <<a, b, c, d, e>>
    g = Base.url_encode64 f

    change(changeset, promo_code_tag: g)
  end
  defp promocode_generator(changeset) do
    changeset
  end
end
