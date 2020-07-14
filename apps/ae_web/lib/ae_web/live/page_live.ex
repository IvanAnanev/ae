defmodule AeWeb.PageLive do
  @moduledoc false
  use AeWeb, :live_view

  @impl true
  def handle_event("change_min_stars", %{"stars" => "all"}, socket) do
    {:noreply, push_patch(socket, to: "/", replace: true)}
  end

  @impl true
  def handle_event("change_min_stars", %{"stars" => min_stars}, socket) do
    {:noreply, push_patch(socket, to: "/?min_stars=#{min_stars}", replace: true)}
  end

  @impl true
  def handle_params(%{"min_stars" => min_stars}, _, socket) do
    categories = Ae.Libs.filtered_list_categories_with_libraries(min_stars)
    {:noreply, assign(socket, categories: categories)}
  end

  @impl true
  def handle_params(%{}, _, socket) do
    categories = Ae.Libs.list_categories_with_libraries()
    {:noreply, assign(socket, categories: categories)}
  end

  def category_with_lib_count(category) do
    "#{category.name} (#{length(category.libraries)})"
  end

  @spec anchor(binary()) :: binary()
  def anchor(category_name) do
    category_name
    |> String.downcase()
    |> String.replace(~r/\/|\(|\)/, "")
    |> String.replace(" ", "-")
  end

  @spec days_ago(Datetime.t()) :: binary()
  def days_ago(nil), do: "-"

  def days_ago(datetime) do
    DateTime.utc_now()
    |> DateTime.diff(datetime)
    |> div(24 * 60 * 60)
  end

  def created_on(nil), do: "-"
  def created_on(datetime), do: DateTime.to_date(datetime)

  def split(arr) do
    length = length(arr)
    part_size = div(length, 2) + rem(length, 2)
    {part_1, part_2} = Enum.split(arr, part_size)
    [part_1, part_2]
  end
end
