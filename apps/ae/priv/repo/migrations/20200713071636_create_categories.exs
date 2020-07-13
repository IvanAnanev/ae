defmodule Ae.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :description, :text, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
