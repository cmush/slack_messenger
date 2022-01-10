defmodule SlackMessengerWeb.ChannelLiveTest do
  use SlackMessengerWeb.ConnCase

  import Phoenix.LiveViewTest
  import SlackMessenger.ChannelsFixtures
  import SlackMessenger.Factory

  @create_attrs %{name: "some name", slack_channel_id: "some slack_channel_id"}
  @update_attrs %{name: "some updated name", slack_channel_id: "some updated slack_channel_id"}
  @invalid_attrs %{name: nil, slack_channel_id: nil}

  defp create_channel(_) do
    channel = insert!(:channel)
    %{channel: channel}
  end

  describe "Index" do
    setup [:create_channel]

    test "lists all channels", %{conn: conn, channel: channel} do
      {:ok, _index_live, html} = live(conn, Routes.channel_index_path(conn, :index))

      assert html =~ "Listing Channels"
      assert html =~ channel.name
    end
  end

  describe "Show" do
    setup [:create_channel]

    test "displays channel", %{conn: conn, channel: channel} do
      {:ok, _show_live, html} = live(conn, Routes.channel_show_path(conn, :show, channel))

      assert html =~ "Show Channel"
      assert html =~ channel.name
    end

    test "updates channel within modal", %{conn: conn, channel: channel} do
      {:ok, show_live, _html} = live(conn, Routes.channel_show_path(conn, :show, channel))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Channel"

      assert_patch(show_live, Routes.channel_show_path(conn, :edit, channel))

      assert show_live
             |> form("#channel-form", channel: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#channel-form", channel: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.channel_show_path(conn, :show, channel))

      assert html =~ "Channel updated successfully"
      assert html =~ "some updated name"
    end
  end
end
