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

      _ ->
        IO.puts "Error"
    end

    loop_accept_clients(socket)
  end
end
