defmodule Promocode.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :event_name, :string
      add :event_longitude, :float
      add :event_latitude, :float
      add :event_worth, :decimal
      add :expiry_date, :naive_datetime
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
