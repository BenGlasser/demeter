defmodule Demeter.Foodtrucks do
  @moduledoc """
  The Foodtrucks context.
  """

  import Ecto.Query, warn: false
  alias Demeter.Repo

  alias Demeter.Foodtrucks.Foodtruck

  @doc """
  Returns the list of foodtrucks.

  ## Examples

      iex> list_foodtrucks()
      [%Foodtruck{}, ...]

  """
  def list_foodtrucks do
    from(Foodtruck,
      order_by: [desc: :favorite, asc: :name]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single foodtruck.

  Raises `Ecto.NoResultsError` if the Foodtruck does not exist.

  ## Examples

      iex> get_foodtruck!(123)
      %Foodtruck{}

      iex> get_foodtruck!(456)
      ** (Ecto.NoResultsError)

  """
  def get_foodtruck!(id), do: Repo.get!(Foodtruck, id)

  @doc """
  Creates a foodtruck.

  ## Examples

      iex> create_foodtruck(%{field: value})
      {:ok, %Foodtruck{}}

      iex> create_foodtruck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_foodtruck(attrs \\ %{}) do
    %Foodtruck{}
    |> Foodtruck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a foodtruck.

  ## Examples

      iex> update_foodtruck(foodtruck, %{field: new_value})
      {:ok, %Foodtruck{}}

      iex> update_foodtruck(foodtruck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_foodtruck(%Foodtruck{} = foodtruck, attrs) do
    foodtruck
    |> Foodtruck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a foodtruck.

  ## Examples

      iex> delete_foodtruck(foodtruck)
      {:ok, %Foodtruck{}}

      iex> delete_foodtruck(foodtruck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_foodtruck(%Foodtruck{} = foodtruck) do
    Repo.delete(foodtruck)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking foodtruck changes.

  ## Examples

      iex> change_foodtruck(foodtruck)
      %Ecto.Changeset{data: %Foodtruck{}}

  """
  def change_foodtruck(%Foodtruck{} = foodtruck, attrs \\ %{}) do
    Foodtruck.changeset(foodtruck, attrs)
  end
end
