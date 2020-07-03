require Logger

defmodule HttpServer do
  def listen do
    {:ok, socket } = :gen_tcp.listen(8080, [:binary, packet: :http_bin, active: false, reuseaddr: true])
    Logger.info "Listening in 8080"
    loop_accept_clients(socket)
  end

  def loop_accept_clients(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    pid = spawn fn -> serve(client) end
    Logger.info("Handling client in process: #{inspect pid}")
    loop_accept_clients(socket)
  end

  def serve(client) do
    data = read(client)
    IO.puts "================"
    IO.inspect data
#    respond(client, data)
    serve(client)
  end

  def read(client) do
    case :gen_tcp.recv(client, 0) do
      {:http_request, method, _, _} ->
        %Connection{method: method}
        read(client)
      {:http_header, _, header_name, _, header_value} ->
        IO.puts "Ya"

      _ ->
        IO.puts("Error")
    end

  end

  def respond(client, data) do
    :gen_tcp.send(client, data)
  end
end
