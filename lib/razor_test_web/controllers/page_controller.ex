defmodule RazorTestWeb.PageController do
  use RazorTestWeb, :controller

  import RazorTest.Controllers.Helpers.AuthHelper

  def index(conn, _params) do
    conn
    |> render("index.html", user: conn.assigns.current_user)
  end

end
