defmodule BlogWeb.Api.PlanetController do
	use BlogWeb, :controller

	alias Blog.Planets

	def index(conn, _params) do
		planets = Planets.all()
		conn
		|> assign(:planets, planets)
		|> render("index.json")
	end
end
