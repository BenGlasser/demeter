defmodule Demeter.FoodtrucksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Demeter.Foodtrucks` context.
  """

  @doc """
  Generate a foodtruck.
  """
  def foodtruck_fixture(attrs \\ %{}) do
    {:ok, foodtruck} =
      attrs
      |> Enum.into(%{
        address: "some address",
        favorite: true,
        fooditems: "some fooditems",
        id: 42,
        lat: 120.5,
        long: 120.5,
        name: "some name",
        schedule: "some schedule"
      })
      |> Demeter.Foodtrucks.create_foodtruck()

    foodtruck
  end
end
