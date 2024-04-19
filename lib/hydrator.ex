defmodule Hydrator do
  @moduledoc """
  The Hydrator module is responsible for hydrating the database with the most recent foodtruck data.
  """
  require Logger

  alias HTTPoison
  @foodtruck_url "https://data.sfgov.org/resource/rqzj-sfat.json"

  def hydrate() do
    @foodtruck_url
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Enum.each(&create_foodtruck/1)
  end

  defp create_foodtruck(%{"objectid" => object_id} = foodtruck) do
    translated_foodtruck = translate(foodtruck)

    %Demeter.Foodtrucks.Foodtruck{}
    |> Demeter.Foodtrucks.Foodtruck.changeset(Map.merge(%{id: object_id}, translated_foodtruck))
    |> Demeter.Repo.insert!(
      on_conflict: [
        set: Map.to_list(translated_foodtruck)
      ],
      conflict_target: :id
    )
  end

  defp create_foodtruck(foodtruck) do
    Logger.warning("Unable to add foodruck: #{inspect(foodtruck)}")
  end

  defp translate(foodtruck) do
    %{}
    |> Map.put(:name, Map.get(foodtruck, "applicant", ""))
    |> Map.put(:address, Map.get(foodtruck, "address", ""))
    |> Map.put(:lat, Map.get(foodtruck, "latitude", ""))
    |> Map.put(:long, Map.get(foodtruck, "longitude", ""))
    |> Map.put(:fooditems, Map.get(foodtruck, "fooditems", ""))
    |> Map.put(:schedule, Map.get(foodtruck, "schedule", ""))
  end
end
