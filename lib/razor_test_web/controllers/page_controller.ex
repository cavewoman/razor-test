defmodule RazorTestWeb.PageController do
  use RazorTestWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
