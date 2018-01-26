defmodule RazorTest.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset
  alias RazorTest.Decks.Deck

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "decks" do
    field :comments, :string
    field :losses, :integer
    field :name, :string
    field :wins, :integer
    field :colors, {:array, :string}
    belongs_to :user, RazorTest.Coherence.User

    many_to_many :cards, RazorTest.Cards.Card, join_through: "card_decks"

    timestamps()
  end

  @doc false
  def changeset(%Deck{} = deck, attrs) do
    deck
    |> cast(attrs, [:name, :wins, :losses, :comments, :colors, :user_id])
    |> validate_required([:name, :user_id])
  end
end
