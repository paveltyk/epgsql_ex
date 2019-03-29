defmodule EpgsqlEx.Proxy do
  use GenServer

  def start_link(opts) do
    hostname = Keyword.get(opts, :hostname)

    normalized_opts =
      (opts ++ [host: hostname])
      |> Keyword.take([:host, :username, :password, :database, :port, :timeout])
      |> Enum.map(&normalize_opt/1)

    GenServer.start_link(__MODULE__, normalized_opts)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal)
  end

  def query(pid, statement) do
    GenServer.call(pid, {:squery, statement})
  end

  def query(pid, statement, []) do
    query(pid, statement)
  end

  def query(pid, statement, params) when is_list(params) do
    GenServer.call(pid, {:equery, statement, params})
  end

  defp normalize_opt({k, v}) when is_binary(v), do: {k, String.to_charlist(v)}
  defp normalize_opt(other), do: other

  # Server

  @impl true
  def init(opts) do
    case :epgsql.connect(opts) do
      {:ok, pid} -> {:ok, pid}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl true
  def terminate(_, pid) do
    :epgsql.close(pid)
  end

  @impl true
  def handle_call({:squery, statement}, _, pid) do
    {:reply, :epgsql.squery(pid, statement), pid}
  end

  @impl true
  def handle_call({:equery, statement, params}, _, pid) do
    {:reply, :epgsql.equery(pid, statement, params), pid}
  end
end
