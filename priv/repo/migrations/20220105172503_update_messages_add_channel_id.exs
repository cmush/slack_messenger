defmodule SlackMessenger.Repo.Migrations.UpdateMessagesAddChannelId do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :channel_id, references(:channels, on_delete: :nothing)
    end
  end
end
