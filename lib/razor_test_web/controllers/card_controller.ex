defmodule RazorTestWeb.CardController do
  use RazorTestWeb, :controller

  alias RazorTest.Users
  alias RazorTest.Users.Card

  def index(conn, _params) do
    cards = Users.list_cards()
    render(conn, "index.html", cards: cards)
  end

  def image_index(conn, _params) do
    cards = Users.list_cards()
    render(conn, "image_index.html", cards: cards)
  end

  def new(conn, _params) do
    changeset = Users.change_card(%Card{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"card" => card_params}) do
    updated_params = updated_params(card_params)
    IO.puts("UPDATED PARAMS")
    IO.inspect(updated_params)
    case Users.create_card(updated_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card created successfully.")
        |> redirect(to: card_path(conn, :show, card))
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Users.get_card!(id)
    render(conn, "show.html", card: card)
  end

  def edit(conn, %{"id" => id}) do
    card = Users.get_card!(id)
    changeset = Users.change_card(card)
    render(conn, "edit.html", card: card, changeset: changeset)
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    card = Users.get_card!(id)

    case Users.update_card(card, card_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card updated successfully.")
        |> redirect(to: card_path(conn, :show, card))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", card: card, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    card = Users.get_card!(id)
    {:ok, _card} = Users.delete_card(card)

    conn
    |> put_flash(:info, "Card deleted successfully.")
    |> redirect(to: card_path(conn, :index))
  end

  defp get_info(name) do
    url_name = name |> String.downcase() |> String.replace(" ", "+")
    url = "https://api.scryfall.com/cards/named?exact=#{url_name}"

    response = HTTPoison.get!(url)
    Poison.decode!(response.body)
  end

  defp updated_params(params) do
    info = get_info(params["name"])
    params
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
  end

  defp maybeAddPowerAndToughness(params, info) do
    if (info["power"]) do
      params
        |> Map.put("power", Integer.parse(info["power"]))
        |> Map.put("toughness", Integer.parse(info["toughness"]))
    else
      params
    end
  end
end
