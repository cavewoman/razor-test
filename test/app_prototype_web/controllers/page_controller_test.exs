defmodule RazorTestWeb.PageControllerTest do
  use RazorTestWeb.ConnCase, async: true
  import RazorTest.Factory

  test "GET /", %{conn: conn} do
    user = insert(:user)
    conn = sign_in(conn, user)
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Deck Box"
  end
end
