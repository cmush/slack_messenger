defmodule SlackMessenger.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :slack_channel_id, :string
      add :name, :string

      timestamps()
    end
  end
end
