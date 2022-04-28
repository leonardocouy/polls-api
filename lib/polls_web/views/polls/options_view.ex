defmodule PollsWeb.Polls.OptionsView do
  use PollsWeb, :view

  def render("index.json", %{options: options}) do
    %{data: render_many(options, __MODULE__, "option.json", as: :option)}
  end

  def render("option.json", %{option: option}) do
    %{
      id: option.id,
      value: option.value,
      poll_id: option.poll_id
    }
  end
end
