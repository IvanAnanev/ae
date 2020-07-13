defmodule Ae.Libs.Library do
  @moduledoc """
  Table libraries.
  """
  import EctoEnum
  import Ecto.Changeset
  use Ecto.Schema

  defenum(StoreType, :store_type, [:github, :no_github])

  @timestamps_opts [type: :utc_datetime]

  schema "libraries" do
    belongs_to :category, Ae.Libs.Category

    field :name, :string
    field :link, :string
    field :description, :string

    field :store_type, Ae.Libs.Library.StoreType
    field :owner, :string, default: ""
    field :repo, :string, default: ""
    field :stars, :integer
    field :last_commited_at, :utc_datetime
    field :github_created_at, :utc_datetime

    timestamps()
  end

  @required_fields ~w(category_id name link description)a
  @optional_fields ~w(owner repo stars last_commited_at github_created_at)a

  def changeset(library, attrs \\ %{}) do
    library
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:name, :category_id])
    |> cast_store_type()
  end

  defp cast_store_type(changeset) do
    owner = get_field(changeset, :owner)
    repo = get_field(changeset, :repo)

    case {owner, repo} do
      {"", ""} -> put_change(changeset, :store_type, :no_github)
      {_o, _r} -> put_change(changeset, :store_type, :github)
    end
  end
end
