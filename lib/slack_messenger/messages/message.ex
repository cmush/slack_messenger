defmodule SlackMessenger.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :subject, :string

    timestamps()

    belongs_to :channel, SlackMessenger.Channels.Channel
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:subject, :body, :channel_id])
    |> validate_required([:subject, :body, :channel_id])
  end
end
