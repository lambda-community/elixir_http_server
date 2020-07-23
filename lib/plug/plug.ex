defmodule Plug.Plug do
  require Connection

  @moduledoc """
    It is a behavior to modify the Struct Connections
  """

  @callback transform(%Connection{method: String.t()}) :: %Connection{}
end
