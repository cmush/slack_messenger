defmodule SlackMessenger.SlackApiClient do
  import SlackMessenger.HttpClient

  def list_public_channels, do: "/conversations.list" |> get()

  def post_message(channel_id, text) when is_binary(channel_id) and is_binary(text),
    do: "/chat.postMessage" |> post(%{"channel" => channel_id, "text" => text})

  def delete_message(channel_id, message_timestamp)
      when is_binary(channel_id) and is_binary(message_timestamp),
      do:
        "/chat.delete"
        |> post(%{
          "channel" => channel_id,
          "ts" => message_timestamp
        })
end
