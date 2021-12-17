defmodule BlogWeb.PostView do
  use BlogWeb, :view

  def render_list_body(markdown) do
    display_text =
      markdown
      |> Earmark.as_html!()
      |> String.slice(0..90)

    if String.length(markdown) > 90 do
      display_text <> "..."
    else
      display_text
    end
  end
end
