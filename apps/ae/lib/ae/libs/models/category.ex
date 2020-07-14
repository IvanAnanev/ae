defmodule Ae.Libs.Category do
  @moduledoc """
  Table categories.
  """
  import Ecto.Changeset
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  schema "categories" do
    field :name, :string
    field :description, :string
    has_many :libraries, Ae.Libs.Library

    timestamps()
  end

  @required_fields ~w(name description)a

  def changeset(category, attrs \\ %{}) do
    category
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
