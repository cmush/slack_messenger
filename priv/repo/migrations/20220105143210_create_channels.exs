defmodule SlackMessenger.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :slack_channel_id, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:channels, [:slack_channel_id])
  end
end
