defmodule Rumbl.Router do
  use Rumbl.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # plug Rumbl.Auth, repo: Rumbl.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Rumbl do
    pipe_through :api
    resources "/matches", MatchController, except: [:new, :edit, :red, :blue]
    get "/red", MatchController, :red
    get "/blue", MatchController, :blue
  end
end
