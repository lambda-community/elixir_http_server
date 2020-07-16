defmodule Connection do
  defstruct method: nil, headers: %{}, request_body: nil, response_body: nil
end
