defmodule SlackMessenger.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias SlackMessenger.Repo

  alias SlackMessenger.{Messages.Message, Channels.Channel}
  alias SlackMessenger.{SlackApiClient, Response}

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)
  def get_message_preload_channel!(id), do: Repo.get!(Message, id) |> Repo.preload(:channel)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> post_to_slack(attrs)
  end

  defp post_to_slack({:ok, %Message{subject: subject, body: body} = message} = _ecto_response, %{
         "slack_channel_id" => slack_channel_id
       }) do
    %Response{body: %{"ts" => message_timestamp} = _body} =
      slack_channel_id
      |> SlackApiClient.post_message("subject: #{subject}; body: #{body}")

    {:ok, %Message{}} = update_response = update_message(message, %{"ts" => message_timestamp})

    update_response
  end

  defp post_to_slack({:error, _changeset} = ecto_response, _params), do: ecto_response

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(
        %Message{ts: message_timestamp, channel: %Channel{slack_channel_id: slack_channel_id}} =
          message
      ) do
    %Response{} = SlackApiClient.delete_message(slack_channel_id, message_timestamp)
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end
end
