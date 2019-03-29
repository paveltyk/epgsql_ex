defmodule EpgsqlEx do
  alias EpgsqlEx.Query

  def child_spec(opts) do
    DBConnection.child_spec(EpgsqlEx.Protocol, opts)
  end

  def execute(conn, query, params, opts) do
    query = %Query{statement: query}
    DBConnection.prepare_execute(conn, query, params, opts)
  end
end
