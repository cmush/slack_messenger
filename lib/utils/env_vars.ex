defmodule SlackMessenger.Utils.EnvVars do
  @moduledoc false

  def slack_base_url,
    do: Application.get_env(:slack_messenger, :base_url) || "http://127.0.0.1:8000"

  def slack_pool_size,
    do: Application.get_env(:slack_messenger, :pool_size) || "5" |> String.to_integer()

  def slack_bot_oauth_token,
    do: Application.get_env(:slack_messenger, :bot_oauth_token)
end
