defmodule SlackMessengerWeb.ChannelLive.Show do
  use SlackMessengerWeb, :live_view

  alias SlackMessenger.Channels

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:channel, Channels.get_channel!(id))}
  end

  defp page_title(:show), do: "Show Channel"
  defp page_title(:edit), do: "Edit Channel"
end
