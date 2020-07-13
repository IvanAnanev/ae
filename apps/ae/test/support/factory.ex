defmodule Ae.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Ae.Repo

  def category_factory do
    %Ae.Libs.Category{
      name: sequence("Category"),
      description: sequence("Category description")
    }
  end

  def library_factory do
    %Ae.Libs.Library{
      category: build(:category),
      name: sequence("library"),
      description: sequence("Library description"),
      link: sequence("https://some.com/link"),
      store_type: :github
    }
  end
end
