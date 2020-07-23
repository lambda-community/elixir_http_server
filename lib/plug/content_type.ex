defmodule Plug.ContentType do
  alias Plug.Plug
  @behaviour Plug

  def transform(conn = %Connection{halt: false}) do
    parse(conn.headers[:"Content-Type"], conn)
  end

  def transform(conn = %Connection{halt: true}) do
    conn
  end

  defp parse("application/json", conn) do
    case Jason.decode(conn.request_body) do
      {:ok, parsed_body} ->
        %Connection{conn | request_body: parsed_body}
      {:error, _} ->
        %Connection{conn | halt: true}
    end
  end

  defp parse("application/x-www-form-urlencoded", conn) do
    conn
  end

  defp parse(_content_type, conn) do
    %Connection{conn | halt: true}
  end
end
