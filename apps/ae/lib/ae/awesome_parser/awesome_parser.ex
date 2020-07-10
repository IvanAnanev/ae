defmodule Ae.AwesomeParser do
  @moduledoc """
  AwesomeParser context.
  """

  @github_api Application.compile_env(:ae, :github_api, Ae.AwesomeParser.GithubApi)

  @spec download_file_for_repo(owner :: binary(), repo :: binary(), file_path :: binary()) ::
          {:ok, Path.t()}
  def download_file_for_repo(owner, repo, file) do
    with {:ok, %{"content" => file_content_base64}} <- @github_api.content(owner, repo, file),
         {:ok, decoded_content} <- Base.decode64(file_content_base64, ignore: :whitespace),
         {:ok, tmp_path} <- Briefly.create(),
         :ok <- File.write(tmp_path, decoded_content) do
      {:ok, tmp_path}
    end
  end
end
