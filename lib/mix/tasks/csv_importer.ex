defmodule Mix.Tasks.CSVImporter do
  use Mix.Task

  alias NimbleCSV.RFC4180, as: CSV
  alias Blog.Planets

  @start_apps [
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  def run(_file) do
    Enum.each(@start_apps, &Application.ensure_all_started/1)
    Blog.Repo.start_link()
    csv_row_to_table_record("lib/mix/tasks/import_files/planets.csv")
  end

  def get_column_names(file) do
    file
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, val} end)
  end

  def csv_row_to_table_record(file) do
    column_names = get_column_names(file)

    file
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: true)
    |> Enum.map(fn row ->
      row
      |> Enum.with_index()
      |> Map.new(fn {val, num} -> {column_names[num], val} end)
      |> Planets.create()
    end)
  end
end
