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
end
