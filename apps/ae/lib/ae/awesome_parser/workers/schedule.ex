defmodule Ae.AwesomeParser.Workers.Schedule do
  @moduledoc false
  use Oban.Worker,
    queue: "default",
    max_attempts: 5,
    tags: ["awesome_parser", "schedule"]

  @owner "h4cc"
  @repo "awesome-elixir"
  @readme "README.md"
  @start_anchor "- [Awesome Elixir](#awesome-elixir)"
  @finish_anchor "- [Resources](#resources)"

  @impl Oban.Worker
  def perform(_job) do
    with {:ok, readme_md_path} <- Ae.AwesomeParser.download_file_for_repo(@owner, @repo, @readme),
         {:ok, categories} <-
           Ae.AwesomeParser.parse_categories(readme_md_path, @start_anchor, @finish_anchor) do
      categories
      |> Stream.map(fn category_name ->
        with {:ok, %{description: description, raw_libs: raw_libs}} <-
               Ae.AwesomeParser.parse_category(readme_md_path, category_name),
             {:ok, category} <-
               Ae.Libs.create_or_update_category(category_name, %{description: description}) do
          handle_raw_libs(raw_libs, category)
        end
      end)
      |> Stream.run()
    end
  end

  defp handle_raw_libs(raw_libs, category) do
    raw_libs
    |> Stream.map(fn raw_lib -> Ae.AwesomeParser.parse_lib(raw_lib) end)
    |> Stream.reject(&match?({:error, _}, &1))
    |> Stream.map(fn {:ok, lib_attrs} ->
      with {:ok, library} <- Ae.Libs.create_or_update_library_for_category(category, lib_attrs),
           true <- match?(:github, library.store_type) do
        Ae.AwesomeParser.async_parse_repo(library)
      end
    end)
    |> Stream.run()
  end
end
