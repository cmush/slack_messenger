defmodule SlackMessenger.ChannelsTest do
  use SlackMessenger.DataCase

  alias SlackMessenger.Channels
  import SlackMessenger.Factory

  setup do
    channel = insert!(:channel)
    [channel: channel]
  end

  describe "channels" do
    alias SlackMessenger.Channels.Channel

    import SlackMessenger.ChannelsFixtures

    @invalid_attrs %{name: nil, slack_channel_id: nil}

    test "list_channels/0 returns all channels", %{channel: channel} do
      assert Channels.list_channels() == [channel]
    end

    test "get_channel!/1 returns the channel with given id", %{channel: channel} do
      assert Channels.get_channel!(channel.id) == channel
    end

    test "create_channel/1 with valid data creates a channel" do
      valid_attrs = %{name: "some name", slack_channel_id: "some slack_channel_id"}

      assert {:ok, %Channel{} = channel} = Channels.create_channel(valid_attrs)
      assert channel.name == "some name"
      assert channel.slack_channel_id == "some slack_channel_id"
    end

    test "create_channel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Channels.create_channel(@invalid_attrs)
    end

    test "update_channel/2 with valid data updates the channel" do
      channel = channel_fixture()

      update_attrs = %{
        name: "some updated name",
        slack_channel_id: "some updated slack_channel_id"
      }

      assert {:ok, %Channel{} = channel} = Channels.update_channel(channel, update_attrs)
      assert channel.name == "some updated name"
      assert channel.slack_channel_id == "some updated slack_channel_id"
    end

    test "update_channel/2 with invalid data returns error changeset" do
      channel = channel_fixture()
      assert {:error, %Ecto.Changeset{}} = Channels.update_channel(channel, @invalid_attrs)
      assert channel == Channels.get_channel!(channel.id)
    end

    test "delete_channel/1 deletes the channel" do
      channel = channel_fixture()
      assert {:ok, %Channel{}} = Channels.delete_channel(channel)
      assert_raise Ecto.NoResultsError, fn -> Channels.get_channel!(channel.id) end
    end

    test "change_channel/1 returns a channel changeset" do
      channel = channel_fixture()
      assert %Ecto.Changeset{} = Channels.change_channel(channel)
    end
  end
end
