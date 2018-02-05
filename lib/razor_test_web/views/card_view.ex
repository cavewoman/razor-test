defmodule RazorTestWeb.CardView do
  use RazorTestWeb, :view

  def csrf_token() do
	   Plug.CSRFProtection.get_csrf_token()
	end

  def getRowColor(colors, name) do
    card_color = ""
    if (Enum.count(colors) == 1) do
      case List.first(colors) do
        "G" ->
          card_color = "green-card"
        "B" ->
          IO.puts("BLACK")
          card_color = "black-card"
        "R" ->
          card_color = "red-card"
        "U" ->
          card_color = "blue-card"
        "W" ->
          card_color = "white-card"
        _ ->
          card_color = "unknown-color-card"
      end
    end
    if (Enum.count(colors) > 1) do
      card_color = "multicolor-card"
    end
    if (Enum.count(colors) == 0) do
      case String.downcase(name) do
        "forest" ->
          card_color = "green-card"
        "swamp" ->
          card_color = "black-card"
        "mountain" ->
          card_color = "red-card"
        "island" ->
          card_color = "blue-card"
        "plains" ->
          card_color = "white-card"
        _ ->
          card_color = "unknown-color-card"
      end
    end
    card_color
  end
end
