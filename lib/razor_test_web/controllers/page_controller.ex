defmodule RazorTestWeb.PageController do
  use RazorTestWeb, :controller

  alias RazorTest.Cards.Card
  alias RazorTest.Cards
  alias RazorTest.Repo

  import Ecto.Query, warn: false

  import RazorTest.Controllers.Helpers.AuthHelper

  def index(conn, _params) do
    user = conn.assigns.current_user
    cards =
      user
      |> Ecto.assoc(:cards)
      |> Repo.all()
      |> length
    decks =
        user
        |> Ecto.assoc(:decks)
        |> Repo.all()
        |> length
    total_card_count = Cards.list_cards_by_name |> length
    conn
    |> render("index.html", user: conn.assigns.current_user, my_cards: cards, my_decks: decks, total_cards: total_card_count)
  end

  def all_cards(conn, _params) do
    cards = Cards.list_cards_by_name
    conn
    |> render("all_cards.html", cards: cards)
  end

  def card(conn, %{"card_id" => card_id, "card_name" => card_name}) do
    user = conn.assigns.current_user
    owned = Cards.user_owns_card?(user, card_name)
    case owned do
      true ->
        card = Cards.get_card_by_name_and_user(card_name, user)
      false ->
        card = Cards.get_card_by_id(card_id)
    end
    conn
    |> render("generic_card.html", card: card, owned: owned, user: user)
  end

end
