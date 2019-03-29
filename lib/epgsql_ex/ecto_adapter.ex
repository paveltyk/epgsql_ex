defmodule EpgsqlEx.EctoAdapter do
  use Ecto.Adapters.SQL,
    driver: :epgsql_ex,
    migration_lock: nil

  @impl true
  def supports_ddl_transaction?, do: false
end
