defmodule Rumbl.MatchTest do
  use Rumbl.ModelCase

  alias Rumbl.Match

  @valid_attrs %{blue_attack: "some content", blue_defence: "some content", red_attack: "some content", red_defence: "some content", score_blue: 42, score_red: 42, started_at: "2010-04-17 14:00:00"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Match.changeset(%Match{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Match.changeset(%Match{}, @invalid_attrs)
    refute changeset.valid?
  end
end
