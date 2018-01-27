defmodule RazorTest.Decks do
  @moduledoc """
  The Decks context.
  """

  import Ecto.Query, warn: false
  alias RazorTest.Repo

  alias RazorTest.Decks.Deck

  @doc """
  Returns the list of decks.

  ## Examples

      iex> list_decks()
      [%Deck{}, ...]

  """
  def list_decks do
    Repo.all(Deck)
  end

  @doc """
  Gets a single deck.

  Raises `Ecto.NoResultsError` if the Deck does not exist.

  ## Examples

      iex> get_deck!(123)
      %Deck{}

      iex> get_deck!(456)
      ** (Ecto.NoResultsError)

  """
  def get_deck!(id), do: Repo.get!(Deck, id)

  @doc """
  Creates a deck.

  ## Examples

      iex> create_deck(%{field: value})
      {:ok, %Deck{}}

      iex> create_deck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_deck(attrs \\ %{}) do
    %Deck{}
    |> Deck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a deck.

  ## Examples

      iex> update_deck(deck, %{field: new_value})
      {:ok, %Deck{}}

      iex> update_deck(deck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_deck(%Deck{} = deck, attrs) do
    deck
    |> Deck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Deck.

  ## Examples

      iex> delete_deck(deck)
      {:ok, %Deck{}}

      iex> delete_deck(deck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_deck(%Deck{} = deck) do
    Repo.delete(deck)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking deck changes.

  ## Examples

      iex> change_deck(deck)
      %Ecto.Changeset{source: %Deck{}}

  """
  def change_deck(%Deck{} = deck, user) do
    Deck.changeset(deck, %{user_id: user.id})
  end

  @doc """
  Returns a `{status, cards}` tuple.

  ## Examples

      iex> params = %{"card_id": "1", "deck_id": "1"}
      iex> add_card_to_deck(params)
      {:ok, [%{name: "Forest", id: 1, small_image_uri: "uri_here"}]}

  """
  def add_card_to_deck(params) do
    {deck_id, _} = Integer.parse(params["deck_id"])
    {card_id, _} = Integer.parse(params["card_id"])

    case insert_card_into_deck(card_id, deck_id) do
      {:ok, _} ->
        case get_cards_for_deck(deck_id) do
          {:ok, result} ->
            cols = Enum.map result.columns, &(String.to_atom(&1))
            cards = Enum.map result.rows, fn(row) -> Enum.into(Enum.zip(cols, row), %{}) end
            {:ok, cards}
          {:error, error} ->
            {:error, error}
        end
      {:error, error} ->
        {:error, error}
    end
  end

  def delete_card_from_deck(card_id, deck_id) do
    {deck_id, _} = Integer.parse(deck_id)
    {card_id, _} = Integer.parse(card_id)
    record_id = get_deck_card_record_id(card_id, deck_id)
    case delete_deck_card(record_id) do
      {:ok, result} ->
        case get_cards_for_deck(deck_id) do
          {:ok, result} ->
            cols = Enum.map result.columns, &(String.to_atom(&1))
            cards = Enum.map result.rows, fn(row) -> Enum.into(Enum.zip(cols, row), %{}) end
            {:ok, cards}
          {:error, error} ->
            {:error, error}
        end
      {:error, error} ->
          {:error, error}
    end
  end

  defp insert_card_into_deck(card_id, deck_id) do
    Repo.query('
    INSERT INTO card_decks
        (card_id, deck_id)
    VALUES
        ($1, $2)', [card_id, deck_id])
  end

  defp delete_deck_card(record_id) do
    Repo.query('DELETE FROM "card_decks"
    WHERE id=$1', [record_id])
  end

  defp get_deck_card_record_id(card_id, deck_id) do
    record = Repo.query!('SELECT *
    FROM "card_decks" AS c0
    WHERE c0."card_id"=$1
    AND c0."deck_id"=$2
    LIMIT 1', [card_id, deck_id])
    record.rows |> List.first |> List.first
  end

  def get_cards_for_deck_id(deck_id) do
    get_cards_for_deck(deck_id)
  end

  defp get_cards_for_deck(deck_id) do
    Repo.query('
    SELECT c1."id", c1."name" , c1."small_image_uri"
    FROM "decks" AS d0
    INNER JOIN "card_decks" AS c2
    ON c2."deck_id" = d0."id"
    INNER JOIN "cards" AS c1
    ON c2."card_id" = c1."id"
    WHERE (d0."id" = $1)
    ORDER BY c1."name"', [deck_id])
  end
end
