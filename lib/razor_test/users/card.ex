defmodule RazorTest.Users.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias RazorTest.Users.Card


  schema "cards" do
    field :name, :string
    field :colors, {:array, :string}
    field :multiverse_ids, {:array, :integer}
    field :number_owned, :integer
    field :scryfall_json_uri, :string
    field :scryfall_uri, :string
    field :type, :string
    field :flavor_text, :string
    field :oracle_text, :string
    field :mana_cost, :string
    field :power, :integer
    field :toughness, :integer
    field :set_name, :string
    field :rulings_uri, :string
    field :rarity, :string
    field :small_image_uri, :string
    field :normal_image_uri, :string
    field :large_image_uri, :string
    field :png_image_uri, :string
    field :art_crop_image_uri, :string
    field :border_crop_image_uri, :string

    timestamps()
  end

  @doc false
  def changeset(%Card{} = card, attrs) do
    card
    |> cast(attrs, [:name,
    :colors,
    :multiverse_ids,
    :number_owned,
    :scryfall_json_uri,
    :scryfall_uri,
    :type,
    :flavor_text,
    :oracle_text,
    :mana_cost,
    :power,
    :toughness,
    :set_name,
    :rulings_uri,
    :rarity,
    :small_image_uri,
    :normal_image_uri,
    :large_image_uri,
    :png_image_uri,
    :art_crop_image_uri,
    :border_crop_image_uri
    ])
  end
end
