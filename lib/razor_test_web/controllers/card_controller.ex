defmodule RazorTestWeb.CardController do
  use RazorTestWeb, :controller

  alias RazorTest.Cards
  alias RazorTest.Cards.Card
  alias RazorTest.Repo

  import RazorTest.Controllers.Helpers.AuthHelper
  import Ecto.Query, warn: false

  plug :assign_requested_user
  def index(conn, _params) do
    user = conn.assigns[:requested_user]

    cards =
      user
      |> Ecto.assoc(:cards)
      |> Ecto.Query.order_by(asc: :name)
      |> Repo.all()

    render conn, "index.html", cards: cards, user: user
  end

  def image_index(conn, _params) do
    user = conn.assigns[:requested_user]
    cards =
      user
      |> Ecto.assoc(:cards)
      |> Ecto.Query.order_by(asc: :name)
      |> Repo.all()
    render(conn, "image_index.html", cards: cards, user: user)
  end

  def new(conn, _params) do
    user = conn.assigns[:requested_user]

    changeset =
      user
      |> Ecto.build_assoc(:cards)
      |> Cards.change_card(%Card{})
    render conn, "new.html", changeset: changeset, user: user
  end

  def create(conn, params) do
    card_params = params["card"]
    user = conn.assigns[:requested_user]
    updated_params = Cards.updated_params(card_params, user)
    case Cards.create_card(updated_params) do
      {:ok, card} ->
        if (params["json_return"]) do
          json(conn, %{redirect_url: card_path(conn, :show, user, card)})
        else
          conn
          |> put_flash(:info, "Card created successfully.")
          |> redirect(to: card_path(conn, :show, user, card))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns[:requested_user]
    card = Repo.get!(Ecto.assoc(user, :cards), id)
    render(conn, "show.html", card: card, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns[:requested_user]

    card = Repo.get!(Ecto.assoc(user, :cards), id)
    changeset = Cards.change_card(card, user)
    render(conn, "edit.html", card: card, changeset: changeset, user: user)
  end

  def update(conn, %{"id" => id, "card" => card_params}) do
    user = conn.assigns[:requested_user]
    card = Repo.get!(Ecto.assoc(user, :cards), id)
    case Cards.update_card(card, card_params) do
      {:ok, card} ->
        conn
        |> put_flash(:info, "Card updated successfully.")
        |> redirect(to: card_path(conn, :show, user, card))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", card: card, changeset: changeset, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:requested_user]
    card = Repo.get!(Ecto.assoc(user, :cards), id)
    {:ok, _card} = Cards.delete_card(card)

    conn
    |> put_flash(:info, "Card deleted successfully.")
    |> redirect(to: card_path(conn, :index, user))
  end

  def prime_cards(conn, params) do
    user = conn.assigns[:requested_user]
    render(conn, "prime_cards.html", user: user)
  end

  def mass_import(conn, params) do
    user = conn.assigns[:requested_user]
    Cards.mass_import(user)
    json(conn, %{ok: "complete"})
  end

end
