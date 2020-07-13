defmodule Ae.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE store_type AS ENUM ('github', 'no_github')",
      "DROP TYPE store_type"
    )

    create table(:libraries) do
      add :category_id, references(:categories, on_delete: :nothing)

      add :name, :string, null: false
      add :link, :string, null: false
      add :description, :text, null: false
      add :store_type, :store_type, null: false

      add :owner, :string
      add :repo, :string
      add :stars, :integer
      add :last_commited_at, :utc_datetime
      add :github_created_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:libraries, [:name, :category_id])
  end
end
