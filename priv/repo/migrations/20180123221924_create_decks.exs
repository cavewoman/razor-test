defmodule RazorTest.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :name, :string
      add :wins, :integer
      add :losses, :integer
      add :comments, :text
      add :colors, {:array, :string}
      add :user_id, :integer

      timestamps()
    end
    create index(:decks, [:name, :user_id])
  end
end
