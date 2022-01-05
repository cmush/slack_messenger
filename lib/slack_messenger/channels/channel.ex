defmodule SlackMessenger.Channels.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :name, :string
    field :slack_channel_id, :string

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:slack_channel_id, :name])
    |> validate_required([:slack_channel_id, :name])
  end
end
