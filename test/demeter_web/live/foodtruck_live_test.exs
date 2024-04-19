defmodule DemeterWeb.FoodtruckLiveTest do
  use DemeterWeb.ConnCase

  import Phoenix.LiveViewTest
  import Demeter.FoodtrucksFixtures

  defp create_foodtruck(_) do
    foodtruck = foodtruck_fixture()
    %{foodtruck: foodtruck}
  end

  describe "Index" do
    setup [:create_foodtruck]

    test "lists all foodtrucks", %{conn: conn, foodtruck: foodtruck} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "Welcome to the Shrine of Demeter"
      assert html =~ foodtruck.name
    end
  end
end
