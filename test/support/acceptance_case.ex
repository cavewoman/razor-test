defmodule RazorTest.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias RazorTest.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import RazorTestWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RazorTest.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(RazorTest.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(RazorTest.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
