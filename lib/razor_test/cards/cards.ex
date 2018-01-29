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

  def mass_import(user) do
    # data = CSVLixir.parse(File.read!("lib/razor_test/cards/all_magic_card_names.csv"))
    data = CSVLixir.read("lib/razor_test/cards/all_magic_card_names.csv")
    |> Enum.to_list
    |> Enum.map(fn(c) -> import_card(c, user) end)
    # IO.inspect(data)
  end

  def import_card(card, user) do
    changeset = %{"name" => List.first(card)}
    params = updated_params(changeset, user)
    create_card(params)
    # IO.inspect(params)
  end

  defp get_info(name) do
    url_name = name |> String.downcase() |> String.replace(" ", "+")
    url = "https://api.scryfall.com/cards/named?exact=#{url_name}"

    response = HTTPoison.get!(url)
    Poison.decode!(response.body)
  end

  def updated_params(params, user) do
    if params["name"] do
      info = get_info(params["name"])
      params
        |> Map.put("user_id", user.id)
        |> Map.put("colors", info["colors"])
        |> Map.put("multiverse_ids", info["multiverse_ids"])
        |> Map.put("scryfall_json_uri", info["uri"])
        |> Map.put("scryfall_uri", info["scryfall_uri"])
        |> Map.put("type", info["type_line"])
        |> Map.put("flavor_text", info["flavor_text"])
        |> Map.put("oracle_text", info["oracle_text"])
        |> Map.put("mana_cost", info["mana_cost"])
        |> Map.put("set_name", info["set_name"])
        |> Map.put("rulings_uri", info["rulings_uri"])
        |> Map.put("rarity", info["rarity"])
        |> Map.put("small_image_uri", info["image_uris"]["small"])
        |> Map.put("normal_image_uri", info["image_uris"]["normal"])
        |> Map.put("large_image_uri", info["image_uris"]["large"])
        |> Map.put("png_image_uri", info["image_uris"]["png"])
        |> Map.put("art_crop_image_uri", info["image_uris"]["art_crop"])
        |> Map.put("border_crop_image_uri", info["image_uris"]["border_crop"])
        |> maybeAddPowerAndToughness(info)
    else
      params
    end
  end

  defp maybeAddPowerAndToughness(params, info) do
    if (info["power"]) do
      params
        |> Map.put("power", transform_combat_value(info["power"]))
        |> Map.put("toughness", transform_combat_value(info["toughness"]))
    else
      params
    end
  end

  def transform_combat_value(combat_value) do
    clean_string = Regex.run(~r/\d+/, combat_value)
    case clean_string do
      nil ->
        clean_string
      _ ->
        clean_string
        |> List.first
        |> String.to_integer
    end
  end
end
