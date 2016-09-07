defmodule Rumbl.MatchChannel do
  use Rumbl.Web, :channel
  alias Rumbl.Match

  def join("matches:lobby", _payload, socket) do
    {:ok, "Connected to channel", socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end

  def time do
    DateTime.utc_now |> DateTime.to_iso8601
  end

  def score(team, count) do
    payload = %{
      "time" => time,
      "team" => team,
      "score" => count,
    }
    Rumbl.Endpoint.broadcast("matches:lobby", "score", payload)
  end

  def players_changed(red_attack,red_defence,blue_attack,blue_defence) do
    payload = %{
      "time" => time,
      "red_attack" => red_attack,
      "red_defence" => red_defence,
      "blue_attack" => blue_attack,
      "blue_defence" => blue_defence
    }
    Rumbl.Endpoint.broadcast("matches:lobby", "players_changed", payload)
  end

  def game_start(match) do
    payload = %{
      "id" => match.id,
      "score_red" => match.score_red,
      "score_blue" => match.score_blue,
      "blue_attack" => match.blue_attack,
      "blue_defence" => match.blue_defence,
      "red_attack" => match.red_attack,
      "red_defence" => match.red_defence,
      "started_at" => match.started_at
    }
    Rumbl.Endpoint.broadcast("matches:lobby", "game_start", payload)
  end

  def set do
    payload = %{
      "time" => DateTime.utc_now |> DateTime.to_iso8601
    }
    Rumbl.Endpoint.broadcast("matches:lobby", "set", payload)
  end

  def game_end do
    payload = %{
      "time" => time
    }
    Rumbl.Endpoint.broadcast("matches:lobby", "game_end", payload)
  end

end
