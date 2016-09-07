defmodule Rumbl.Match do
  use Rumbl.Web, :model

  schema "matches" do
    field :red_attack, :string
    field :red_defence, :string
    field :blue_attack, :string
    field :blue_defence, :string
    field :score_red, :integer
    field :score_blue, :integer
    field :started_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(red_attack red_defence blue_attack blue_defence score_red score_blue started_at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
