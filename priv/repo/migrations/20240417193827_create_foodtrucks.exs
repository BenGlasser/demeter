defmodule Demeter.Repo.Migrations.CreateFoodtrucks do
  use Ecto.Migration

  def change do
    create table(:foodtrucks) do
      add :name, :string
      add :lat, :float
      add :long, :float
      add :address, :string
      add :fooditems, :text
      add :schedule, :text
      add :favorite, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
