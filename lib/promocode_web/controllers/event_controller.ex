defmodule PromocodeWeb.EventController do
  use PromocodeWeb, :controller

  alias Promocode.EventsPromocode
  alias Promocode.EventsPromocode.Event

  action_fallback PromocodeWeb.FallbackController

  def index(conn, _params) do
    events = EventsPromocode.list_events()
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    # with {:ok, %Event{} = event} <- EventsPromocode.create_event(event_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", Routes.event_path(conn, :show, event))
    #   |> render("show.json", event: event)
    # end

    case EventsPromocode.create_event(event_params) do
      {:ok, %Event{} = event} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.event_path(conn, :show, event))
        |> render("show.json", event: event)
      # {:error, %Ecto.Changeset{}} ->
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{errors: %{detail: PromocodeWeb.ChangesetView.translate_errors(changeset)}})
        # render(conn, "error.json", changeset)
      _ ->
        json(conn, %{errors: %{detail: "Sorry we are working on this"}})
    end
  end

  def show(conn, %{"id" => id}) do
    event = EventsPromocode.get_event!(id)
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = EventsPromocode.get_event!(id)

    with {:ok, %Event{} = event} <- EventsPromocode.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = EventsPromocode.get_event!(id)

    with {:ok, %Event{}} <- EventsPromocode.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
