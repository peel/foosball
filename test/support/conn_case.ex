defmodule Rumbl.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Rumbl.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import Rumbl.Router.Helpers
      import Rumbl.TestHelpers

      # The default endpoint for testing
      @endpoint Rumbl.Endpoint
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Rumbl.Repo, [])
    end

    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end
