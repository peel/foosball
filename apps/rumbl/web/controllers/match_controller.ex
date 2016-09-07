defmodule Rumbl.MatchController do
  use Rumbl.Web, :controller
  require Logger

  alias Rumbl.Match
  alias Rumbl.MatchChannel

  plug :scrub_params, "match" when action in [:create, :update]

  def index(conn, _params) do
    matches = Repo.all(Match)
    render(conn, "index.json", matches: matches)
  end

  def create(conn, %{"match" => %{"red_attack" => red_attack , "red_defence" => red_defence, "blue_defence" => blue_defence, "blue_attack" => blue_attack}}) do
    changeset = Match.changeset(%Match{}, %{"score_blue" => 0, "score_red"=> 0, "started_at" => DateTime.utc_now() |> DateTime.to_iso8601, "red_attack"=> red_attack, "red_defence"=> red_defence, "blue_attack"=> blue_attack, "blue_defence"=> blue_defence})
    case Repo.insert(changeset) do
      {:ok, match} ->
        rasbperry_started
        MatchChannel.game_start(match)
        conn
        |> put_status(:created)
        |> put_resp_header("location", match_path(conn, :show, match))
        |> render("show.json", match: match)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rumbl.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    match = Repo.get!(Match, id)
    render(conn, "show.json", match: match)
  end

  def red(conn, _params) do
    match = Repo.one!(from m in Match, order_by: [desc: m.id], limit: 1)
    rasbperry_score("red", match.score_red+1, match.score_blue)
    cond do
      match.score_red+1 < 8 ->
        MatchChannel.score("red",match.score_red+1)
      match.score_red+1 == 8 ->
        MatchChannel.score("red",match.score_red+1)
        MatchChannel.game_end
      true ->
        MatchChannel.game_end
    end
    changeset = Match.changeset(match, %{"score_red" => match.score_red+1})
    case Repo.update(changeset) do
      {:ok, match} ->
        render(conn, "show.json", match: match)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rumbl.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def blue(conn, _params) do
    match = Repo.one!(from m in Match, order_by: [desc: m.id], limit: 1)
    changeset = Match.changeset(match, %{"score_blue" => match.score_blue+1})
    rasbperry_score("blue", match.score_red, match.score_blue+1)
    cond do
      match.score_blue+1 < 8 ->
        MatchChannel.score("blue",match.score_blue+1)
      match.score_blue+1 == 8 ->
        MatchChannel.score("blue",match.score_blue+1)
        MatchChannel.game_end
      true ->
        MatchChannel.game_end
    end
    case Repo.update(changeset) do
      {:ok, match} ->
        render(conn, "show.json", match: match)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rumbl.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "match" => match_params}) do
    match = Repo.get!(Match, id)
    changeset = Match.changeset(match, match_params)

    case Repo.update(changeset) do
      {:ok, match} ->
        MatchChannel.players_changed(match.red_attack, match.red_defence, match.blue_attack, match.blue_defence)
        render(conn, "show.json", match: match)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Rumbl.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    match = Repo.get!(Match, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(match)

    send_resp(conn, :no_content, "")
  end


  def rasbperry_started() do
    HTTPoison.start
    HTTPoison.get("10.168.10.23:3000/start")
  end
  def rasbperry_score(team, score_red, score_blue) do
    HTTPoison.start
    payload = Poison.encode!(%{"red" => score_red, "blue" => score_blue, "set" => 0})
    HTTPoison.post("10.168.10.23:3000/update", payload, headers = [{"Content-type", "application/json"}])
  end
end
