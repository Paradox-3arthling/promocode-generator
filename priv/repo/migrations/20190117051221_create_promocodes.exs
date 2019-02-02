defmodule Promocode.Repo.Migrations.CreatePromocodes do
  use Ecto.Migration

  def change do
    create table(:promocodes) do
      add :promo_code_tag, :string
      add :is_active, :boolean, default: true, null: false
      add :in_use, :boolean, default: false, null: false
      add :promo_code_worth, :decimal
      add :event_id, references(:events, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:promocodes, [:promo_code_tag])
    create index(:promocodes, [:event_id])
  end
end
