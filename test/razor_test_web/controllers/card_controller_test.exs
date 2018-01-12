defmodule RazorTestWeb.CardControllerTest do
  use RazorTestWeb.ConnCase

  import RazorTest.Factory

  alias RazorTest.Cards

  @create_attrs %{name: "Forest", number_owned: 4}
  @update_attrs %{name: "some updated name", number_owned: 5}
  @invalid_attrs %{name: nil, number_owned: nil}

  def fixture(:card) do
    {:ok, card} = Cards.create_card(@create_attrs)
    card
  end

  setup %{conn: conn} do
    user = insert(:user)
    card = insert(:card)
    conn =
      conn
      |> sign_in(user)

    {:ok, [conn: conn, user: user, card: card]}
  end

  describe "index" do
    test "lists all cards", %{conn: conn} do
      conn = get conn, card_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Cards"
    end
  end

  describe "new card" do
    test "renders form", %{conn: conn} do
      conn = get conn, card_path(conn, :new)
      assert html_response(conn, 200) =~ "New Card"
    end
  end

  describe "create card" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn1 = post conn, card_path(conn, :create), card: @create_attrs

      assert %{id: id} = redirected_params(conn1)
      assert redirected_to(conn1) == card_path(conn1, :show, id)

      conn2 = get conn, card_path(conn, :show, id)
      assert html_response(conn2, 200) =~ "Forest"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, card_path(conn, :create), card: @invalid_attrs
      assert html_response(conn, 200) =~ "New Card"
    end
  end

  describe "edit card" do

    test "renders form for editing chosen card", %{conn: conn, card: card} do
      conn = get conn, card_path(conn, :edit, card)
      assert html_response(conn, 200) =~ "Edit Card"
    end
  end

  describe "show card" do

    test "renders chosen card", %{conn: conn, card: card} do
      conn = get conn, card_path(conn, :show, card)
      assert html_response(conn, 200) =~ "Island"
    end
  end

  describe "update card" do

    test "redirects when data is valid", %{conn: conn, card: card} do
      conn1 = put conn, card_path(conn, :update, card), card: @update_attrs
      assert redirected_to(conn1) == card_path(conn, :show, card)

      conn2 = get conn, card_path(conn, :show, card)
      assert html_response(conn2, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, card: card} do
      conn = put conn, card_path(conn, :update, card), card: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Card"
    end
  end

  describe "delete card" do

    test "deletes chosen card", %{conn: conn, card: card} do
      conn1 = delete conn, card_path(conn, :delete, card)
      assert redirected_to(conn1) == card_path(conn1, :index)
      assert_error_sent 404, fn ->
        get conn, card_path(conn, :show, card)
      end
    end
  end

end
