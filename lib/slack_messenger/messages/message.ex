defmodule SlackMessenger.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string
    field :subject, :string
    field :ts, :string

    timestamps()

    belongs_to :channel, SlackMessenger.Channels.Channel
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:subject, :body, :ts, :channel_id])
    |> validate_required([:subject, :body, :channel_id])
  end

  @doc false
  def update_changeset(message, attrs) do
    message
    |> cast(attrs, [:ts])
  end
end
