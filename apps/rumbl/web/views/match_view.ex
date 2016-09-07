defmodule Rumbl.MatchView do
  use Rumbl.Web, :view

  def render("index.json", %{matches: matches}) do
    %{data: render_many(matches, Rumbl.MatchView, "match.json")}
  end

  def render("show.json", %{match: match}) do
    %{data: render_one(match, Rumbl.MatchView, "match.json")}
  end

  def render("match.json", %{match: match}) do
    %{id: match.id,
      red_attack: match.red_attack,
      red_defence: match.red_defence,
      blue_attack: match.blue_attack,
      blue_defence: match.blue_defence,
      score_red: match.score_red,
      score_blue: match.score_blue,
      started_at: match.started_at}
  end
end
