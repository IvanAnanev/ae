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
end
