defmodule Rumbl.Repo.Migrations.CreateMatch do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :red_attack, :string
      add :red_defence, :string
      add :blue_attack, :string
      add :blue_defence, :string
      add :score_red, :integer
      add :score_blue, :integer
      add :started_at, :datetime

      timestamps
    end

  end
end
