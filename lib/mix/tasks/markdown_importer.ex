defmodule Mix.Tasks.MarkdownImporter do
  @moduledoc """
  Importer for blog posts in .md

  to execute in terminal run 'mix PostImporter'
  """
  use Mix.Task

  alias Blog.Posts

  def run(_file) do
    import_blog_posts_export("lib/mix/tasks/import_files/blog_posts_export.md")
  end

  def import_blog_posts_export(file) do
    Mix.Task.run("app.start")
    {:ok, result} = File.read(file)

    posts = String.split(result, "## ")

    Enum.map(posts, fn post ->
      if post != "" do
        [title, body] = String.split(post, "\n\n", parts: 2)
        body = String.replace_suffix(body, "\n\n\n----------\n\n\n", "")

        case Posts.create_post(%{"body" => body, "title" => title}) do
          {:ok, post} ->
            IO.inspect(post, label: "RIGHT HERE - post")

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.inspect(changeset, label: "RIGHT HERE - changeset")
        end
      end
    end)
  end
end
