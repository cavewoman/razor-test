defmodule RazorTestWeb.DeckController do
  use RazorTestWeb, :controller

  alias RazorTest.Decks
  alias RazorTest.Decks.Deck
  alias RazorTest.Repo
  alias RazorTest.Coherence.User
  alias RazorTest.Cards.Card

  import RazorTest.Controllers.Helpers.AuthHelper
  import Ecto.Query, warn: false

  plug :assign_requested_user
  def index(conn, _params) do
    user = conn.assigns[:requested_user]

    decks =
      user
      |> Ecto.assoc(:decks)
      |> Ecto.Query.order_by(desc: :name)
      |> Repo.all()

    render(conn, "index.html", decks: decks, user: user)
  end

  def new(conn, _params) do
    user = conn.assigns[:requested_user]

    changeset =
      user
      |> Ecto.build_assoc(:decks)
      |> Decks.change_deck(%Deck{})
    render(conn, "new.html", changeset: changeset, user: user)
  end

  def create(conn, %{"deck" => deck_params}) do
    user = conn.assigns[:requested_user]
    updated_params = deck_params |> Map.put("user_id", user.id)
    case Decks.create_deck(updated_params) do
      {:ok, deck} ->
        conn
        |> put_flash(:info, "Deck created successfully.")
        |> redirect(to: deck_path(conn, :show, user, deck))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns[:requested_user]
    deck = Repo.get!(Ecto.assoc(user, :decks), id) |> Repo.preload([cards: (from c in Card, order_by: c.name)])

    cards = Repo.all(Ecto.assoc(user, :cards))

    render(conn, "show.html", deck: deck, user: user, cards: cards, deck_cards: deck.cards)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns[:requested_user]

    deck = Repo.get!(Ecto.assoc(user, :decks), id) |> Repo.preload([cards: (from c in Card, order_by: c.name)])

    cards = Repo.all(Ecto.assoc(user, :cards))

    changeset = Decks.change_deck(deck, user)
    render(conn, "edit.html", deck: deck, changeset: changeset, user: user, cards: cards, deck_cards: deck.cards)
  end

  def update(conn, %{"id" => id, "deck" => deck_params}) do
    user = conn.assigns[:requested_user]
    deck = Repo.get!(Ecto.assoc(user, :decks), id)

    case Decks.update_deck(deck, deck_params) do
      {:ok, deck} ->
        conn
        |> put_flash(:info, "Deck updated successfully.")
        |> redirect(to: deck_path(conn, :show, user, deck))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", deck: deck, changeset: changeset, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:requested_user]
    deck = Repo.get!(Ecto.assoc(user, :decks), id)
    {:ok, _deck} = Decks.delete_deck(deck)

    conn
    |> put_flash(:info, "Deck deleted successfully.")
    |> redirect(to: deck_path(conn, :index, user))
  end

  def add_card(conn, %{"card_deck_params" => params}) do
    case Decks.add_card_to_deck(params) do
      {:ok, cards} ->
        json(conn, %{cards: cards})
      {:error, error} ->
        json(conn, %{error: error})
    end
  end

  def delete_card(conn, %{"card_id" => card_id, "deck_id" => deck_id}) do
    case Decks.delete_card_from_deck(card_id, deck_id) do
      {:ok, cards} ->
        json(conn, %{cards: cards})
      {:error, error} ->
        json(conn, %{error: error})
    end
  end
end
