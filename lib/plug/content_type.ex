defmodule Plug.ContentType do
  alias Plug.Plug
  @behaviour Plug

  def transform(conn = %Connection{}) do
    IO.inspect(is_atom(conn.method))
    IO.inspect(conn.headers[:"Content-Type"])
    conn
  end
end
