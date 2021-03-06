defmodule MiphaWeb.ReplyController do
  use MiphaWeb, :controller

  alias Mipha.{Stars, Replies, Topics}

  plug MiphaWeb.Plug.RequireUser when action in ~w(create edit update delete star unstar)a

  def action(conn, _) do
    topic = Topics.get_topic!(conn.params["topic_id"])
    apply(__MODULE__, action_name(conn), [conn, conn.params, topic])
  end

  def create(conn, %{"reply" => reply_params}, topic) do
    case Replies.insert_reply(current_user(conn), reply_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Reply created successfully.")
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:success, "Reply created error.")
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def edit(conn, %{"id" => id}, topic) do
    reply = Replies.get_reply!(id)
    changeset = Replies.change_reply(reply)

    render conn, :edit,
      topic: topic,
      changeset: changeset,
      reply: reply,
      topic: topic
  end

  def update(conn, %{"id" => id, "reply" => reply_params}, topic) do
    reply = Replies.get_reply!(id)
    case Replies.update_reply(reply, reply_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Reply updated successfully.")
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:success, "Reply updated error.")
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def delete(conn, %{"id" => id}, topic) do
    reply = Replies.get_reply!(id)
    {:ok, _reply} = Replies.delete_reply(reply)

    conn
    |> put_flash(:info, "Reply deleted successfully.")
    |> redirect(to: topic_path(conn, :show, topic))
  end

  def star(conn, %{"reply_id" => reply_id}, topic) do
    reply = Replies.get_reply!(reply_id)
    attrs = %{
      user_id: current_user(conn).id,
      reply_id: reply.id
    }
    case Stars.insert_star(attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "star successfully")
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:danger, "star error")
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end

  def unstar(conn, %{"reply_id" => reply_id}, topic) do
    reply = Replies.get_reply!(reply_id)
    attrs = [
      user_id: current_user(conn).id,
      reply_id: reply.id
    ]
    case Stars.delete_star(attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "unstar successfully")
        |> redirect(to: topic_path(conn, :show, topic))

      {:error, _} ->
        conn
        |> put_flash(:danger, "unstar error")
        |> redirect(to: topic_path(conn, :show, topic))
    end
  end
end
