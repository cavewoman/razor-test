defmodule RazorTest.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :colors, {:array, :string}
      add :multiverse_ids, {:array, :string}
      add :number_owned, :integer
      add :scryfall_json_uri, :string
      add :scryfall_uri, :string
      add :type, :string
      add :flavor_text, :string
      add :oracle_text, :string
      add :mana_cost, :string
      add :power, :integer
      add :toughness, :integer
      add :set_name, :string
      add :rulings_uri, :string
      add :rarity, :string
      add :small_image_uri, :string
      add :normal_image_uri, :string
      add :large_image_uri, :string
      add :png_image_uri, :string
      add :art_crop_image_uri, :string
      add :border_crop_image_uri, :string

      timestamps()
    end
    create unique_index(:cards, [:name])
  end
end
