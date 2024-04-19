defmodule Demeter.FoodtrucksTest do
  use Demeter.DataCase

  alias Demeter.Foodtrucks

  describe "foodtrucks" do
    alias Demeter.Foodtrucks.Foodtruck

    import Demeter.FoodtrucksFixtures

    @invalid_attrs %{
      id: nil,
      name: nil,
      address: nil,
      long: nil,
      lat: nil,
      fooditems: nil,
      schedule: nil,
      favorite: nil
    }

    test "list_foodtrucks/0 returns all foodtrucks" do
      foodtruck = foodtruck_fixture()
      assert Foodtrucks.list_foodtrucks() == [foodtruck]
    end

    test "get_foodtruck!/1 returns the foodtruck with given id" do
      foodtruck = foodtruck_fixture()
      assert Foodtrucks.get_foodtruck!(foodtruck.id) == foodtruck
    end

    test "create_foodtruck/1 with valid data creates a foodtruck" do
      valid_attrs = %{
        id: 42,
        name: "some name",
        address: "some address",
        long: 120.5,
        lat: 120.5,
        fooditems: "some fooditems",
        schedule: "some schedule",
        favorite: true
      }

      assert {:ok, %Foodtruck{} = foodtruck} = Foodtrucks.create_foodtruck(valid_attrs)
      assert foodtruck.id == 42
      assert foodtruck.name == "some name"
      assert foodtruck.address == "some address"
      assert foodtruck.long == 120.5
      assert foodtruck.lat == 120.5
      assert foodtruck.fooditems == "some fooditems"
      assert foodtruck.schedule == "some schedule"
      assert foodtruck.favorite == true
    end

    test "create_foodtruck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Foodtrucks.create_foodtruck(@invalid_attrs)
    end

    test "update_foodtruck/2 with valid data updates the foodtruck" do
      foodtruck = foodtruck_fixture()

      update_attrs = %{
        id: 43,
        name: "some updated name",
        address: "some updated address",
        long: 456.7,
        lat: 456.7,
        fooditems: "some updated fooditems",
        schedule: "some updated schedule",
        favorite: false
      }

      assert {:ok, %Foodtruck{} = foodtruck} =
               Foodtrucks.update_foodtruck(foodtruck, update_attrs)

      assert foodtruck.id == 43
      assert foodtruck.name == "some updated name"
      assert foodtruck.address == "some updated address"
      assert foodtruck.long == 456.7
      assert foodtruck.lat == 456.7
      assert foodtruck.fooditems == "some updated fooditems"
      assert foodtruck.schedule == "some updated schedule"
      assert foodtruck.favorite == false
    end

    test "update_foodtruck/2 with invalid data returns error changeset" do
      foodtruck = foodtruck_fixture()
      assert {:error, %Ecto.Changeset{}} = Foodtrucks.update_foodtruck(foodtruck, @invalid_attrs)
      assert foodtruck == Foodtrucks.get_foodtruck!(foodtruck.id)
    end

    test "delete_foodtruck/1 deletes the foodtruck" do
      foodtruck = foodtruck_fixture()
      assert {:ok, %Foodtruck{}} = Foodtrucks.delete_foodtruck(foodtruck)
      assert_raise Ecto.NoResultsError, fn -> Foodtrucks.get_foodtruck!(foodtruck.id) end
    end

    test "change_foodtruck/1 returns a foodtruck changeset" do
      foodtruck = foodtruck_fixture()
      assert %Ecto.Changeset{} = Foodtrucks.change_foodtruck(foodtruck)
    end
  end
end
