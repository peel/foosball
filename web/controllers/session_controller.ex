defmodule Rumbl.SessionController do
	use Rumbl.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
   case Rumbl.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
     {:ok, conn} ->
       conn
       |> put_flash(:info, "welcome back!")
       |> redirect(to: page_path(conn, :index))
     {:error, _reason, conn} ->
       conn
       |> put_flash(:error, "invalid username/password")
       |> render("new.html")
   end
  end

  def delete(conn, _) do
    conn
    |> Rumbl.Auth.logout()
    |> put_flash(:info, "you have been logged out")
    |> redirect(to: page_path(conn, :index))
  end

end