defmodule RazorTest.Repo.Migrations.CreateCardDecks do
  use Ecto.Migration

  def change do
    create table(:card_decks) do
      add :card_id, :integer
      add :deck_id, :integer
    end

    create index(:card_decks, [:card_id, :deck_id])
  end
end
