defmodule Ae.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Ae.Repo

  def category_factory do
    %Ae.Libs.Category{
      name: sequence("Category"),
      description: sequence("Category description")
    }
  end
end
