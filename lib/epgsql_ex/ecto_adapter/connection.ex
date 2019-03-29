defmodule EpgsqlEx.EctoAdapter.Connection do
  @behaviour Ecto.Adapters.SQL.Connection

  @impl true
  def child_spec(opts) do
    EpgsqlEx.child_spec(opts)
  end

  @impl true
  def execute(conn, sql, params, opts) do
    EpgsqlEx.execute(conn, sql, params, opts)
  end

  @impl true
  def prepare_execute(conn, _name, sql, params, opts) do
    EpgsqlEx.execute(conn, sql, params, opts)
  end

  @impl true
  def all(_query) do
    :TODO
  end

  # Not implemented

  @impl true
  def delete(_prefix, _table, _filters, _returning) do
    not_implemented()
  end

  @impl true
  def delete_all(_query) do
    not_implemented()
  end

  @impl true
  def execute_ddl(_command) do
    not_implemented()
  end

  @impl true
  def ddl_logs(_result) do
    not_implemented()
  end

  @impl true
  def update(_prefix, _table, _fields, _filters, _returning) do
    not_implemented()
  end

  @impl true
  def update_all(_query) do
    not_implemented()
  end

  @impl true
  def insert(_prefix, _table, _header, _rows, _on_conflict, _returning) do
    not_implemented()
  end

  @impl true
  def to_constraints(_exception) do
    not_implemented()
  end

  @impl true
  def stream(_connection, _statement, _params, _options) do
    not_implemented()
  end

  @impl true
  def query(_connection, _statement, _params, _options) do
    not_implemented()
  end

  defp not_implemented, do: raise("Not implemented")
end
