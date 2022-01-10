defmodule SlackMessenger.MessagesTest do
  use SlackMessenger.DataCase

  alias SlackMessenger.Messages
  alias SlackMessenger.Factory

  setup do
    channel = insert!(:channel)
    message = insert!(:message, channel_id: channel.id)
    [channel: channel, message: message]
  end

  describe "messages" do
    alias SlackMessenger.Messages.Message

    @invalid_attrs %{ts: 120}

    test "list_messages/0 returns all messages", %{message: message} do
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id", %{message: message} do
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message", %{channel: channel} do
      valid_attrs = %{body: "some body", subject: "some subject", channel_id: channel.id}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.body == "some body"
      assert message.subject == "some subject"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message", %{message: message} do
      update_attrs = %{ts: "1641389759.000200"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.ts == "1641389759.000200"
    end

    test "update_message/2 with invalid data returns error changeset", %{message: message} do
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message", %{message: message} do
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset", %{message: message} do
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
