defmodule SlackMessengerWeb.ChannelLive.Index do
  use SlackMessengerWeb, :live_view

  alias SlackMessenger.Channels
  alias SlackMessenger.Channels.Channel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :channels, list_channels())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Channel")
    |> assign(:channel, Channels.get_channel!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Channel")
    |> assign(:channel, %Channel{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Channels")
    |> assign(:channel, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    channel = Channels.get_channel!(id)
    {:ok, _} = Channels.delete_channel(channel)

    {:noreply, assign(socket, :channels, list_channels())}
  end

  defp list_channels do
    Channels.list_channels()
  end
end
