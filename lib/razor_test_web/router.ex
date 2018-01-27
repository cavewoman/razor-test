defmodule RazorTestWeb.Router do
  use RazorTestWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", RazorTestWeb do
    pipe_through :browser # Use the default browser stack

    # get "/", PageController, :index
  end

  scope "/", RazorTestWeb do
    pipe_through :protected
    get "/", PageController, :index
    get "/all-cards", PageController, :all_cards
    get "/generic-card/:card_id/:card_name", PageController, :card
    scope "/:user_id" do
      resources "/cards", CardController
      get "/card-images", CardController, :image_index
      resources "/decks", DeckController
      post "/add-card-to-deck", DeckController, :add_card
      post "/delete-card-from-deck", DeckController, :delete_card
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", RazorTest do
  #   pipe_through :api
  # end
end
