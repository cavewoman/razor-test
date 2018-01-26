defmodule RazorTestWeb.DeckControllerTest do
  use RazorTestWeb.ConnCase

  import RazorTest.Factory

  alias RazorTest.Decks
  alias RazorTest.Repo

  @create_attrs %{comments: "some comments", losses: 42, name: "some name", wins: 42}
  @update_attrs %{comments: "some updated comments", losses: 43, name: "some updated name", wins: 43}
  @invalid_attrs %{comments: nil, losses: nil, name: nil, wins: nil}

  def fixture(:deck) do
    {:ok, deck} = Decks.create_deck(@create_attrs)
    deck
  end

  setup %{conn: conn} do
    user = insert(:user)

    deck =
      user
      |> Ecto.build_assoc(:decks,
                     build(:deck,
                           %{
                             name: "My Deck",
                             comments: "Comments about my Deck",
                             losses: 2,
                             wins: 50,
                             colors: ["G"]
                           }))
      |> Repo.insert!()

    conn =
      conn
      |> sign_in(user)

    {:ok, [conn: conn, user: user, deck: deck]}
  end

  describe "index" do
    test "lists all decks", %{conn: conn, user: user} do
      conn = get conn, deck_path(conn, :index, user)
      assert html_response(conn, 200) =~ "Listing Decks"
    end
  end

  describe "new deck" do
    test "renders form", %{conn: conn, user: user} do
      conn = get conn, deck_path(conn, :new, user)
      assert html_response(conn, 200) =~ "New Deck"
    end
  end

  describe "create deck" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn1 = post conn, deck_path(conn, :create, user), deck: @create_attrs

      assert %{id: id} = redirected_params(conn1)
      assert redirected_to(conn1) == deck_path(conn1, :show, user, id)

      conn2 = get conn, deck_path(conn, :show, user, id)
      assert html_response(conn2, 200) =~ "some name"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post conn, deck_path(conn, :create, user), deck: @invalid_attrs
      assert html_response(conn, 200) =~ "New Deck"
    end
  end

  describe "edit deck" do

    test "renders form for editing chosen deck", %{conn: conn, deck: deck, user: user} do
      conn = get conn, deck_path(conn, :edit, user, deck)
      assert html_response(conn, 200) =~ "Edit Deck"
    end
  end

  describe "update deck" do

    test "redirects when data is valid", %{conn: conn, deck: deck, user: user} do
      conn1 = put conn, deck_path(conn, :update, user, deck), deck: @update_attrs
      assert redirected_to(conn1) == deck_path(conn, :show, user, deck)

      conn2 = get conn, deck_path(conn, :show, user, deck)
      assert html_response(conn2, 200) =~ "some updated comments"
    end

  end

  describe "delete deck" do

    test "deletes chosen deck", %{conn: conn, deck: deck, user: user} do
      conn1 = delete conn, deck_path(conn, :delete, user, deck)
      assert redirected_to(conn1) == deck_path(conn1, :index, user)
      assert_error_sent 404, fn ->
        get conn, deck_path(conn, :show, user, deck)
      end
    end
  end
end
