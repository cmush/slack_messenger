defmodule SlackMessenger.Repo.Migrations.UpdateMessagesAlterTsUnique do
  use Ecto.Migration

  def change do
    create unique_index(:messages, [:ts])
  end
end
