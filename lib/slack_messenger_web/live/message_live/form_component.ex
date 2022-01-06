defmodule SlackMessengerWeb.MessageLive.FormComponent do
  use SlackMessengerWeb, :live_component

  alias SlackMessenger.Messages
  alias SlackMessenger.{SlackApiClient, Response}

  @impl true
  def update(%{message: message} = assigns, socket) do
    changeset = Messages.change_message(message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      socket.assigns.message
      |> Messages.change_message(message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"message" => message_params}, socket) do
    save_message(socket, socket.assigns.action, message_params)
  end

  defp save_message(socket, :edit, message_params) do
    case Messages.update_message(socket.assigns.message, message_params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_message(socket, :new, %{"subject" => subject, "body" => body} = message_params) do
    with %Response{
           body: %{
             "channel" => _channel_id,
             "message" => %{
               "bot_id" => _bot_id,
               "text" => _text,
               "ts" => message_timestamp,
               "type" => "message"
             },
             "ok" => true
           }
         } <-
           socket.assigns.slack_channel_id
           |> SlackApiClient.post_message("subject: #{subject}; body: #{body}"),
         {:ok, _message} <-
           Messages.create_message(
             message_params
             |> Map.put("ts", message_timestamp)
             |> Map.put("channel_id", socket.assigns.channel_id)
           ) do
      {:noreply,
       socket
       |> put_flash(:info, "Message created successfully")
       |> push_redirect(to: "#{socket.assigns.return_to}?channel_id=#{socket.assigns.channel_id}")}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
