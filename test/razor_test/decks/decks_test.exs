defmodule RazorTest.DecksTest do
  use RazorTest.DataCase

  alias RazorTest.Decks
  import RazorTest.Factory

  describe "decks" do
    alias RazorTest.Decks.Deck

    @valid_attrs %{comments: "some comments", losses: 42, name: "some name", wins: 42}
    @update_attrs %{comments: "some updated comments", losses: 43, name: "some updated name", wins: 43}
    @invalid_attrs %{comments: nil, losses: nil, name: nil, wins: nil}


    def deck_fixture(attrs \\ %{}) do
      user = insert(:user)
      deck_fixture_with_user(attrs, user)
    end

    def deck_fixture_with_user(attrs \\ %{}, user) do
      user
      |> Ecto.build_assoc(:decks,
                     build(:deck,
                           @valid_attrs))
      |> Repo.insert!()
    end

    test "list_decks/0 returns all decks" do
      deck = deck_fixture()
      assert Decks.list_decks() == [deck]
    end

    test "get_deck!/1 returns the deck with given id" do
      deck = deck_fixture()
      assert Decks.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      user = insert(:user)
      Ecto.build_assoc(user, :cards)
      changeset = Map.put(@valid_attrs, :user_id, user.id)
      assert {:ok, %Deck{} = deck} = Decks.create_deck(changeset)
      assert deck.comments == "some comments"
      assert deck.losses == 42
      assert deck.name == "some name"
      assert deck.wins == 42
    end

    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Decks.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = deck_fixture()
      assert {:ok, deck} = Decks.update_deck(deck, @update_attrs)
      assert %Deck{} = deck
      assert deck.comments == "some updated comments"
      assert deck.losses == 43
      assert deck.name == "some updated name"
      assert deck.wins == 43
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = deck_fixture()
      assert {:error, %Ecto.Changeset{}} = Decks.update_deck(deck, @invalid_attrs)
      assert deck == Decks.get_deck!(deck.id)
    end

    test "delete_deck/1 deletes the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{}} = Decks.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Decks.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      user = insert(:user)
      deck = deck_fixture_with_user(user)
      assert %Ecto.Changeset{} = Decks.change_deck(deck, user)
    end
  end
end
