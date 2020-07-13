defmodule Ae.Libs do
  @moduledoc """
  Libs context.
  """

  alias Ae.Libs.{Category, Library}

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

  @spec create_or_update_library_for_category(category :: Category.t(), attrs :: map()) ::
          {:ok, Library.t()} | {:error, Ecto.Changeset.t()}
  def create_or_update_library_for_category(
        %Category{id: category_id} = _category,
        %{"name" => name} = attrs
      ) do
    library =
      case Ae.Repo.get_by(Library, category_id: category_id, name: name) do
        nil -> %Library{category_id: category_id}
        library -> library
      end

    library
    |> Library.changeset(attrs)
    |> Ae.Repo.insert_or_update()
  end
end
