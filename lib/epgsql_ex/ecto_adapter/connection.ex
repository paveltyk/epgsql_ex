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
  def all(query) do
    sources = create_names(query)
    from = from(query, sources)
    select = select(query, sources)

    [select, from]
  end

  # Query generation

  defp select(%{select: %{fields: fields}}, sources) do
    fields = intersperse_map(fields, ", ", &expr(&1, sources), [])
    ["SELECT ", fields]
  end

  defp from(%{from: %{source: source}}, sources) do
    {from, name} = get_source(sources, 0, source)
    [" FROM ", from, " AS ", name]
  end

  defp expr({{:., _, [{:&, _, [idx]}, field]}, _, []}, sources) do
    {_, source, _} = elem(sources, idx)
    [source, ?., quote_name(field)]
  end

  defp create_names(%{sources: sources}) do
    create_names(sources, 0, tuple_size(sources)) |> List.to_tuple()
  end

  defp create_names(sources, pos, limit) when pos < limit do
    [create_name(sources, pos), create_names(sources, pos + 1, limit)]
  end

  defp create_names(_sources, pos, pos), do: []

  defp create_name(sources, pos) do
    {table, schema, _prefix} = elem(sources, pos)
    name = [create_alias(table), Integer.to_string(pos)]
    {quote_name(table), name, schema}
  end

  defp create_alias(<<first, _rest::binary>>) when first in ?a..?z when first in ?A..?Z do
    <<first>>
  end

  defp get_source(sources, ix, source) do
    {expr, name, _schema} = elem(sources, ix)
    {expr || expr(source, sources), name}
  end

  defp quote_name(name) when is_atom(name), do: quote_name(Atom.to_string(name))

  defp quote_name(name), do: [?", name, ?"]

  defp intersperse_map([elem], _separator, mapper, acc), do: [acc, mapper.(elem)]

  defp intersperse_map([elem | rest], separator, mapper, acc) do
    intersperse_map(rest, separator, mapper, [acc, mapper.(elem), separator])
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
