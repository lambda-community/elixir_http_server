defmodule Plug.Response do
  alias Plug.Plug
  @behaviour Plug

  def transform(conn) do
    parse(conn.headers[:"Content-Type"], conn)
  end

  defp parse("application/json", conn) do
    # TODO: use response body,
    case Jason.encode(conn.request_body) do
      {:ok, encoded_body} ->
        %Connection{conn | response_body: encoded_body}
      {:error, _} ->
        %Connection{conn | halt: true}
    end
  end

  defp parse(_content_type, conn) do
    %Connection{conn | response_body: conn.request_body }
  end

end
