defmodule RazorTest.Factory do
  use ExMachina.Ecto, repo: RazorTest.Repo
  alias RazorTest.Coherence.User
  alias RazorTest.Cards.Card
  alias RazorTest.Decks.Deck
  # Sample user factory
  # def user_factory do
  #   %User{
  #     name: "Test User 1",
  #     email: sequence(:email, &"testuser#{&1}@example.com"),
  #   }
  # end

  def user_factory do
    %User{name: "Test User",
          email: sequence(:email, &"testuser#{&1}@example.com"),
          password: "password",
          password_confirmation: "password",
          password_hash: Comeonin.Bcrypt.hashpwsalt("password")}
  end

  def card_factory do
    %Card{name: "Island",
          number_owned: 3,
          }
  end

  def deck_factory do
    %Deck{name: "Test Deck",
          comments: "Test deck comments",
          losses: 34,
          wins: 54,
          colors: ["W"]
    }
  end
end
