defmodule RazorTestWeb.DeckView do
  use RazorTestWeb, :view

  def csrf_token() do
	   Plug.CSRFProtection.get_csrf_token()
	end
end
