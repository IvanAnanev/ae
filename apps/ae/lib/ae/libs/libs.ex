defmodule Ae.Libs do
  @moduledoc """
  Libs context.
  """

  alias Ae.Libs.Category

  @spec create_or_update_category(category_name :: binary(), attrs :: map()) ::
          {:ok, Categoty.t()} | {:error, Ecto.Changeset.t()}
  def create_or_update_category(category_name, attrs) do
    category =
      case Ae.Repo.get_by(Category, name: category_name) do
        nil -> %Category{name: category_name}
        category -> category
      end

    category
    |> Category.changeset(attrs)
    |> Ae.Repo.insert_or_update()
  end
end
