defmodule SlackMessenger.Repo.Migrations.UpdateMessagesAddTs do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :ts, :string
    end
  end
end
