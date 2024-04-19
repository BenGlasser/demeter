defmodule DemeterWeb.FoodtruckLive.Index do
  use DemeterWeb, :live_view

  alias Demeter.Foodtrucks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :foodtrucks, Foodtrucks.list_foodtrucks())}
  end

  @impl true
  def handle_info({DemeterWeb.FoodtruckLive.FormComponent, {:saved, foodtruck}}, socket) do
    {:noreply, stream_insert(socket, :foodtrucks, foodtruck)}
  end

  @impl true
  def handle_event("toggle_favorite", %{"id" => id}, socket) do
    foodtruck = Foodtrucks.get_foodtruck!(id)
    {:ok, foodtruck} = Foodtrucks.update_foodtruck(foodtruck, %{favorite: not foodtruck.favorite})

    {:noreply, stream_insert(socket, :foodtrucks, foodtruck)}
  end
end
