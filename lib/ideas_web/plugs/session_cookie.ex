defmodule IdeasWeb.SessionCookiePlug do
  import Plug.Conn
  alias Ideas.Meetup

  @user_salt "WO4vYPYKHZTenX/OwZ4M2b9G8oEr04HQ37h8JRB1yZlnP3aA4I35BQxeU65wPPiQ"

  def init(default), do: default

  def call(conn, _default) do
    token = cookies(conn, "user_token")

    {conn, session} =
      case Phoenix.Token.verify(conn, @user_salt, token, max_age: 86400) do
        {:ok, session_id} ->
          # IO.inspect(session_id, label: "Valid token")

          case Meetup.get_session(session_id) do
            nil ->
              # IO.inspect(session_id, label: "Session not found")
              create_new_session(conn)

            session ->
              # IO.inspect(session, label: "Existing Session found")
              {conn, session}
          end

        {:error, _} ->
          # IO.inspect(token, label: "Invalid Token")
          create_new_session(conn)
      end

    # IO.inspect(conn, label: "SessionCookiePlug conn: ")

    assign(conn, :session, session)
  end

  defp create_new_session(conn) do
    {:ok, session} = Meetup.create_session(%{name: "SessionName"})
    write_cookie(conn, session)
  end

  defp write_cookie(conn, session) do
    token = Phoenix.Token.sign(conn, @user_salt, session.id)
    conn = put_resp_cookie(conn, "user_token", token)
    {conn, session}
  end

  defp cookies(conn, cookie_name) do
    conn.cookies[cookie_name]
  end
end
