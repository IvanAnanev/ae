defmodule Ae.AwesomeParser.Workers.ParseRepo do
  @moduledoc false
  use Oban.Worker,
    queue: "default",
    max_attempts: 5,
    tags: ["awesome_parser", "parse_repo"]

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}}) do
    with {:ok, %{owner: owner, repo: repo} = library} <- Ae.Libs.find_library_by_id(id),
         {:ok, parsed_attrs} <- Ae.AwesomeParser.parse_repo_info(owner, repo) do
      Ae.Libs.update_library(library, parsed_attrs)
    end
  end
end
