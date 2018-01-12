defmodule RazorTest.AuthTestHelper do
  import Plug.Conn

  def sign_in(conn,
              user \\ %{id: 1, first_name: "FirstName", last_name: "LastName"}) do
    conn
    |> assign(:current_user, user)
  end
end
