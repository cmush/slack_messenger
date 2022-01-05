defmodule SlackMessenger.ChannelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SlackMessenger.Channels` context.
  """

  @doc """
  Generate a channel.
  """
  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slack_channel_id: "some slack_channel_id"
      })
      |> SlackMessenger.Channels.create_channel()

    channel
  end
end
