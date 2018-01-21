defmodule RazorTest.CardsTest do
  use RazorTest.DataCase

  alias RazorTest.Cards

  import RazorTest.Factory

  describe "cards" do
    alias RazorTest.Cards.Card

    @invalid_attrs %{name: nil, type: nil}

    def card_fixture(attrs \\ %{}) do
      user = insert(:user)
      card_fixture_with_user(attrs, user)
    end

    def card_fixture_with_user(attrs \\ %{}, user) do
      user
      |> Ecto.build_assoc(:cards,
                     build(:card,
                           %{
                             name: "some name",
                             type: "some type" ,
                           }))
      |> Repo.insert!()
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Cards.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Cards.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      user = insert(:user)
      user
      |> Ecto.build_assoc(:cards)
      changeset = %{name: "some name", type: "some type", user_id: user.id}
      assert {:ok, card} = Cards.create_card(changeset)
      assert card.name == "some name"
      assert card.type == "some type"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      user = insert(:user)
      card = card_fixture_with_user(user)
      update_attrs = %{name: "updated name", type: "updated type"}
      assert {:ok, card} = Cards.update_card(card, update_attrs)
      assert %Card{} = card
      assert card.name == "updated name"
      assert card.type == "updated type"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_card(card, @invalid_attrs)
      assert card == Cards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Cards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      user = insert(:user)
      card = card_fixture_with_user(user)
      assert %Ecto.Changeset{} = Cards.change_card(card, user)
    end
  end
end
