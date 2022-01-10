defmodule SlackMessengerWeb.PageControllerTest do
  use SlackMessengerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "SlackMessenger"
    assert html_response(conn, 200) =~ "Home"
    assert html_response(conn, 200) =~ "Dashboard"
    assert html_response(conn, 200) =~ "Open Channels"
  end
end
