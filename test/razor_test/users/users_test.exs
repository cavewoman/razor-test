defmodule RazorTest.UsersTest do
  use RazorTest.DataCase

  alias RazorTest.Users

  describe "cards" do
    alias RazorTest.Users.Card

    @valid_attrs %{name: "some name", type: "some type"}
    @update_attrs %{name: "some updated name", type: "some updated type"}
    @invalid_attrs %{name: nil, type: nil}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Users.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Users.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Users.create_card(@valid_attrs)
      assert card.name == "some name"
      assert card.type == "some type"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, card} = Users.update_card(card, @update_attrs)
      assert %Card{} = card
      assert card.name == "some updated name"
      assert card.type == "some updated type"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_card(card, @invalid_attrs)
      assert card == Users.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Users.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Users.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Users.change_card(card)
    end
  end
end
