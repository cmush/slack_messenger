defmodule SlackMessenger.SlackApiClient do
  import SlackMessenger.HttpClient

  def list_public_channels, do: "/conversations.list" |> get()

  def post_message(channel_id, text) when is_binary(channel_id) and is_binary(text),
    do: "/chat.postMessage" |> post_application_json(%{"channel" => channel_id, "text" => text})

  def delete_message(channel_id, message_timestamp)
      when is_binary(channel_id) and is_binary(message_timestamp),
      do:
        "/chat.delete"
        |> post_application_json(%{
          "channel" => channel_id,
          "ts" => message_timestamp
        })

  def conversations_history(channel_id) when is_binary(channel_id) do
    "/conversations.history"
    |> post_application_x_www_form_urlencoded(%{channel: channel_id}, [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end
end
