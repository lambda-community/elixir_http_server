require Logger

defmodule HttpServer do
  def listen do
    {:ok, socket } = :gen_tcp.listen(8080, [:binary, packet: :line, active: false, reuseaddr: true])
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
    respond(client, data)
    serve(client)
  end

  def read(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, data} ->
        data
      _ ->
        IO.puts("Error")
    end

  end

  def respond(client, data) do
    :gen_tcp.send(client, data)
  end
end
