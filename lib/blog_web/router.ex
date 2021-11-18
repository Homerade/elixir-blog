defmodule BlogWeb.Router do
  use BlogWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: ["http://localhost:3000"]
    plug :accepts, ["json"]
  end

  pipeline :logged_in do
    # plug Web.Plugs.EnsureUser, as: :web
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", BlogWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/posts", PostController

    get "/password-reset", PasswordResetController, :new

    post "/password-reset", PasswordResetController, :create

    get "/password-reset/verify/:token", PasswordResetController, :edit

    post "/password-reset/verify", PasswordResetController, :update

    resources "/create-account", RegistrationController, only: [:create, :new]

    resources "/login", SessionController, only: [:new, :create]

    get "/planets", PlanetController, :index
  end

  scope "/", BlogWeb do
    pipe_through([:browser, :logged_in])

    get "/dashboard", DashboardController, :index
  end

  scope "/api", BlogWeb.Api, as: :api do
    pipe_through :api

    resources("/planets", PlanetController, only: [:create, :index])
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BlogWeb.Telemetry
    end
  end
end
