defmodule RazorTest.Cards do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias RazorTest.Repo

  alias RazorTest.Cards.Card

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  def list_cards_by_name do
    Repo.all(from(c in Card, distinct: c.name, order_by: [c.name]))
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id), do: Repo.get!(Card, id)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{source: %Card{}}

  """
  def change_card(%Card{} = card, user) do
    Card.changeset(card, %{user_id: user.id})
  end

  def user_owns_card?(user, card_name) do
    user_ids = user_ids_by_card_name(card_name)
    owned = Enum.member?(user_ids, user.id)
  end

  defp user_ids_by_card_name(name) do
    Repo.all(from(c in Card,
    where: c.name == ^name,
    select: c.user_id))
  end

  def get_card_by_id(id) do
    Repo.get!(Card, id)
  end

  def get_card_by_name_and_user(name, user) do
    Repo.all(from(c in Card,
    where: c.user_id == ^user.id and c.name == ^name))
    |> List.first
  end
end
