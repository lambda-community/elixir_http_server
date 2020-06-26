require Logger

defmodule HttpServer do
  @moduledoc """
  Documentation for `HttpServer`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> HttpServer.hello()
      :world

  """
  def listen do
    {:ok, socket } = :gen_tcp.listen(8080, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info "Listening in 8080"
    loop_accept_clients(socket)
  end

  def loop_accept_clients(socket) do
    case :gen_tcp.accept(socket) do
      {:ok, client} ->
        IO.puts "Entro un cliente"
        serve(client,data)
      _ ->
        IO.puts "Error"
    end

    loop_accept_clients(socket)
  end

  def read(client) do
    case :gen_tcp.recv(client, 0) do
      {:ok, data} ->
        data
      _ ->
        IO.puts("Error")
    end

  end

  def serve(client, data) do
    data = read(client)
    :gen_tcp.send(client, data)
  end
end
