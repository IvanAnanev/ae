defmodule Ae.AwesomeParserTest do
  use Ae.DataCase, async: true
  alias Ae.AwesomeParser
  import Mox

  @content_encoded_base64 Base.encode64("Some content")

  describe "download_file_for_repo/3" do
    test "success" do
      Ae.AwesomeParser.GithubApi.Mock
      |> expect(:content, fn _owner, _repo, _file ->
        {:ok, %{content: @content_encoded_base64}}
      end)

      assert match?({:ok, _}, AwesomeParser.download_file_for_repo("owner", "repo", "file"))
    end
  end

  @readme_path "test/examples/awesome_elixir_test.md"
  @start_anchor "- [Awesome Elixir](#awesome-elixir)"
  @finish_anchor "- [Resources](#resources)"

  describe "parse_categories/3" do
    test "success" do
      {:ok, categories} =
        AwesomeParser.parse_categories(@readme_path, @start_anchor, @finish_anchor)

      assert ["Category A", "Category B", "Category C"] == categories
    end
  end

  @category_name "Category C"

  describe "parse_category/2" do
    test "success" do
      {:ok, result} = AwesomeParser.parse_category(@readme_path, @category_name)

      assert "Category C description." == result.description

      assert [
               "* [lib_c_1](https://github.com/owner_c_1/lib_c_1) - Description library C 1.",
               "* [lib_c_2](https://github.com/owner_c_2/lib_c_2) - Description library C 2."
             ] == result.raw_libs
    end
  end
end
