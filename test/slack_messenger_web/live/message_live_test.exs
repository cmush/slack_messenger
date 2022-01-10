defmodule SlackMessengerWeb.MessageLiveTest do
  use SlackMessengerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SlackMessenger.Factory

  @create_attrs %{body: "some body", subject: "some subject"}
  @invalid_attrs %{body: nil, subject: nil}

  defp create_message(_) do
    channel = insert!(:channel)
    message = insert!(:message, channel_id: channel.id)
    %{channel: channel, message: message}
  end

  describe "Index" do
    setup [:create_message]

    test "lists all messages", %{conn: conn, message: message} do
      {:ok, _index_live, html} = live(conn, Routes.message_index_path(conn, :index))

      assert html =~ "Listing Messages"
      assert html =~ message.body
    end

    test "saves new message", %{conn: conn, channel: channel} do
      {:ok, index_live, _html} =
        live(conn, Routes.message_index_path(conn, :index, channel_id: channel.id))

      assert index_live |> element("a", "New Message") |> render_click() =~
               "New Message"

      assert_patch(index_live, Routes.message_index_path(conn, :new))

      assert index_live
             |> form("#message-form", message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#message-form", message: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.message_index_path(conn, :index, channel_id: channel.id))

      assert html =~ "Message created successfully"
      assert html =~ "test body"
    end

    test "deletes message in listing", %{conn: conn, message: message} do
      {:ok, index_live, _html} = live(conn, Routes.message_index_path(conn, :index))

      assert index_live |> element("#message-#{message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#message-#{message.id}")
    end
  end

  describe "Show" do
    setup [:create_message]

    test "displays message", %{conn: conn, message: message} do
      {:ok, _show_live, html} = live(conn, Routes.message_show_path(conn, :show, message))

      assert html =~ "Show Message"
      assert html =~ message.body
    end
  end
end
