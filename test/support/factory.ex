defmodule SlackMessenger.Factory do
  alias SlackMessenger.Repo
  alias SlackMessenger.Channels.Channel
  alias SlackMessenger.Messages.Message

  # Factories

  def build(:channel) do
    %Channel{name: "slack-messenger-test", slack_channel_id: "C02ST1D1D8B"}
  end

  def build(:message) do
    %Message{subject: "test subject", body: "test body", channel_id: 1, ts: "1641390441.000500"}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
