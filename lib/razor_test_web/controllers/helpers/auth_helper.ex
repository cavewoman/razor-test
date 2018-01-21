defmodule RazorTest.Controllers.Helpers.AuthHelper do
  @moduledoc "Controller helpers functions for handling authentication\n"

  import Plug.Conn
  import Phoenix.Controller

  alias RazorTest.Coherence.User
  alias RazorTest.Repo

  def assign_requested_user(conn, _opts) do
    case conn.params do
      %{"user_id" => user_id} ->
        case Repo.get(User, user_id) do
          nil ->
            invalid_user conn

          user ->
            result = assign conn, :requested_user, user
            result
        end

      _ ->
        invalid_user conn
    end
  end


  def invalid_user(conn) do
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: "/")
    |> halt
  end


  def authorize_current_user_or_admin(conn, _opts) do
    is_authorized = is_current_user(conn)
    case is_authorized do
      true ->
        conn

      _ ->
        render_auth_error(conn)
      end
  end


  # def authorize_admin_user(conn, _opts) do
  #   case is_admin(conn) do
  #     true ->
  #       conn
  #
  #       _ ->
  #         render_auth_error(conn)
  #   end
  # end


  # defp is_admin(conn) do
  #   user = conn.assigns[:current_user]
  #   user && user.is_admin
  # end


  defp is_current_user(conn) do
    user = conn.assigns[:current_user]
    user && Integer.to_string(user.id) == conn.params["user_id"]
  end

  defp render_auth_error(conn) do
    conn
    |> put_flash(:error, "You are not authorized to view that page.")
    |> redirect(to: "/")
    |> halt()
  end
end
