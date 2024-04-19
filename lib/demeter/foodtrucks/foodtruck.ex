defmodule Demeter.Foodtrucks.Foodtruck do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:id]
  @optional [:name, :lat, :long, :address, :fooditems, :schedule, :favorite]
  @fields @optional ++ @required

  @derive {Jason.Encoder, only: @fields}
  schema "foodtrucks" do
    field :name, :string
    field :address, :string
    field :long, :float
    field :lat, :float
    field :fooditems, :string
    field :schedule, :string
    field :favorite, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(foodtruck, attrs) do
    foodtruck
    |> cast(attrs, @fields)
    |> validate_required(@required)
  end
end
