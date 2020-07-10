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

  @spec parse_categories(
          readme_md :: Path.t(),
          start_anchor :: binary(),
          finish_anchor :: binary()
        ) :: {:ok, categories :: [binary()]}
  def parse_categories(readme_md, start_anchor, finish_anchor) do
    categories =
      readme_md
      |> File.stream!()
      |> Stream.map(&String.trim/1)
      |> Stream.reject(&String.equivalent?(&1, ""))
      |> Enum.to_list()
      |> Enum.reduce_while({[], false}, fn line, {acc, flag_parse} ->
        cond do
          String.equivalent?(line, start_anchor) ->
            {:cont, {acc, true}}

          String.equivalent?(line, finish_anchor) ->
            {:halt, acc}

          flag_parse ->
            {:cont, {acc ++ [line], flag_parse}}

          true ->
            {:cont, {acc, flag_parse}}
        end
      end)
      |> Enum.map(&String.replace(&1, ~r/(^\-\ \[)|(\]\(.*\))/, ""))

    {:ok, categories}
  end
end
