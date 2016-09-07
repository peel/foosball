defmodule Rumbl.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "matches:lobby", Rumbl.MatchChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  @max_age 2 * 7 * 24 * 60 * 60 * 1000

  def connect(%{"token" => token}, socket) do
    {:ok, assign(socket, :user_id, token)}
  end
  def connect(_params, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
