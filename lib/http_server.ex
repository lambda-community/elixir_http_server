
defmodule HttpServer do
  require Logger
  require Plug.ContentType
  require Plug.Response

  def listen do
    {:ok, socket } = :gen_tcp.listen(8080, [:binary, packet: :http_bin, active: false, reuseaddr: true])
    Logger.info "Listening in 8080"
    loop_accept_clients(socket)
  end

  defp loop_accept_clients(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    pid = spawn fn -> serve(client) end
    Logger.info("Handling client in process: #{inspect pid}")
    loop_accept_clients(socket)
  end

  defp serve(client) do
    connection = read(client, %Connection{})
    IO.puts "================"
    IO.inspect connection
    IO.puts "================"

    connection
      |> Plug.ContentType.transform
      |> Plug.Response.transform
      |> respond(client)
      |> :gen_tcp.close

  end

  defp read(client, connection) do
    case :gen_tcp.recv(client, 0) do
      {:ok, {:http_request, method, _, _} } ->
        conn = %Connection{connection | method: method}
        read(client, conn)

      {:ok, {:http_header, _, header_name, _, header_value}} ->
        conn = %Connection{connection | headers: Map.put(connection.headers, header_name, header_value)}
        read(client, conn)

      {:ok, :http_eoh} ->
        :inet.setopts(client, [packet: :raw])
        case :gen_tcp.recv(client, 0) do
          {:ok, body} ->
            %Connection{connection | request_body: body}

          _ ->
            connection
        end
    end
  end

  defp respond(connection, client) do
    response_body = """
    HTTP/1.1 200 ok

    #{connection.response_body}
    """
    :gen_tcp.send(client, response_body)
    client
  end
end
