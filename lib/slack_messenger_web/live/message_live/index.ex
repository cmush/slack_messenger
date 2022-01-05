defmodule SlackMessengerWeb.MessageLive.Index do
  use SlackMessengerWeb, :live_view

  alias SlackMessenger.{Messages, Messages.Message, Channels, Channels.Channel}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:messages, list_messages()) |> assign(slack_channel_id: nil)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Messages.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, %{"channel_id" => channel_id}) do
    %Channel{slack_channel_id: slack_channel_id} = Channels.get_channel!(channel_id)

    socket
    |> assign(:page_title, "Listing Messages")
    |> assign(:message, nil)
    |> assign(:slack_channel_id, slack_channel_id)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Messages.get_message!(id)
    {:ok, _} = Messages.delete_message(message)

    {:noreply, assign(socket, :messages, list_messages())}
  end

  defp list_messages do
    Messages.list_messages()
  end
end
