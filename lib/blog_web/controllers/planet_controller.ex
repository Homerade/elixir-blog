defmodule BlogWeb.PlanetController do
	use BlogWeb, :controller

	alias Blog.Planets

	def index(conn, _params) do
		planets = Planets.all()

		conn
		|> assign(:planets, planets)
		|> render("index.html")
	end
end
