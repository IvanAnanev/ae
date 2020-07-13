defmodule Ae.AwesomeParser.GithubApi do
  @moduledoc """
  GithubApi wrap for githup api with Tentacat.
  """
  defmodule Behaviour do
    @moduledoc false
    @callback content(owner :: binary(), repo :: binary(), path :: binary()) ::
                {:ok, body :: map()} | {:error, any()}
    @callback repo_get(owner :: binary(), repo :: binary()) ::
                {:ok, body :: map()} | {:error, any()}
  end

  @behaviour Behaviour

  @impl true
  def content(owner, repo, path) do
    api_client()
    |> Tentacat.Repositories.Contents.content(owner, repo, path)
    |> handle_response()
  end

  @impl true
  def repo_get(owner, repo) do
    api_client()
    |> Tentacat.Repositories.repo_get(owner, repo)
    |> handle_response()
  end

  defp handle_response(response) do
    case response do
      {200, body, _} -> {:ok, body}
      {:error, _} = err -> err
      error -> {:error, error}
    end
  end

  defp api_client do
    Tentacat.Client.new(%{
      access_token: Application.get_env(:ae, Ae.AwesomeParser.GithubApi)[:token]
    })
  end
end
