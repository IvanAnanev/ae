defmodule Ae.LibsTest do
  use Ae.DataCase, async: true
  alias Ae.Libs

  describe "create_or_update_category/2" do
    test "create" do
      {:ok, category} =
        Libs.create_or_update_category("Category A", %{
          "description" => "Category A description."
        })

      assert match?(%{name: "Category A", description: "Category A description."}, category)
    end

    test "update" do
      insert(:category, name: "Category A")

      {:ok, category} =
        Libs.create_or_update_category("Category A", %{
          "description" => "Category A description."
        })

      assert match?(%{name: "Category A", description: "Category A description."}, category)
    end

    test "fail" do
      assert match?(
               {:error, %Ecto.Changeset{}},
               Libs.create_or_update_category("Category A", %{})
             )
    end
  end

  describe "create_or_update_library_for_category/2" do
    setup do
      {:ok, category: insert(:category)}
    end

    test "create github library", %{category: category} do
      {:ok, library} =
        Libs.create_or_update_library_for_category(category, %{
          "name" => "some",
          "link" => "https://github.com/owner/repo",
          "description" => "Some description.",
          "owner" => "owner",
          "repo" => "repo"
        })

      assert library.store_type == :github
    end

    test "create no_github library", %{category: category} do
      {:ok, library} =
        Libs.create_or_update_library_for_category(category, %{
          "name" => "some",
          "link" => "https://hex.pm/packages/repo",
          "description" => "Some description.",
          "owner" => "",
          "repo" => ""
        })

      assert library.store_type == :no_github
    end

    test "update", %{category: category} do
      library = insert(:library, category: category, name: "library")

      {:ok, updated_library} =
        Libs.create_or_update_library_for_category(category, %{
          "name" => "library",
          "link" => "https://github.com/owner/repo",
          "description" => "Some description.",
          "owner" => "owner",
          "repo" => "repo"
        })

      assert updated_library.id == library.id
    end

    test "fail", %{category: category} do
      assert match?(
               {:error, %Ecto.Changeset{}},
               Libs.create_or_update_library_for_category(category, %{"name" => "some"})
             )
    end
  end

  describe "find_library_by_id/1" do
    test "success" do
      %{id: id} = insert(:library)
      assert match?({:ok, %Ae.Libs.Library{}}, Libs.find_library_by_id(id))
    end

    test "fail" do
      assert {:error, :not_found} == Libs.find_library_by_id(100_500)
    end
  end

  describe("update_library/2") do
    test "succes" do
      library = insert(:library)

      assert match?(
               {:ok, %Ae.Libs.Library{}},
               Libs.update_library(library, %{last_commited_at: DateTime.utc_now()})
             )
    end
  end
end
