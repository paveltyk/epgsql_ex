defmodule EpgsqlEx.Query do
  defstruct [:statement]

  defimpl DBConnection.Query do
    def parse(query, _opts), do: query

    def describe(query, _opts), do: query

    def encode(_query, params, _opts), do: params

    def decode(_query, {:ok, columns, rows}, _opts) do
      rows = Enum.map(rows, &normalize_row(&1, columns))
      %{columns: columns, rows: rows, num_rows: length(rows)}
    end

    defp normalize_row(row, columns) when is_tuple(row) and is_list(columns) do
      row |> Tuple.to_list() |> normalize_row(columns, [])
    end

    defp normalize_row([val | vals], [col | cols], acc) do
      type = elem(col, 2)

      casted_val =
        case {type, val} do
          {:int4, val} when is_binary(val) -> String.to_integer(val)
          {:int8, val} when is_binary(val) -> String.to_integer(val)
          {_type, val} -> val
        end

      normalize_row(vals, cols, acc ++ [casted_val])
    end

    defp normalize_row([], [], acc), do: acc
  end

  defimpl String.Chars do
    alias EpgsqlEx.Query

    def to_string(%{statement: sttm}) do
      case sttm do
        sttm when is_binary(sttm) -> IO.iodata_to_binary(sttm)
        %{statement: %Query{} = q} -> String.Chars.to_string(q)
      end
    end
  end
end
