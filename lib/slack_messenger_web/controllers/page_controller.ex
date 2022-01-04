defmodule SlackMessengerWeb.PageController do
  use SlackMessengerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
