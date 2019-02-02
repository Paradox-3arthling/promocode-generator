defmodule PromocodeWeb.PromocodeController do
  use PromocodeWeb, :controller

  require Logger
          # Logger.info "link_insertion: #{inspect(link_insertion)}"

  alias Promocode.EventsPromocode
  alias Promocode.EventsPromocode.{Promocode, Event, Promocodevalidation}

  action_fallback PromocodeWeb.FallbackController

  def index(conn, _params) do
    promocodes = EventsPromocode.list_promocodes()
    render(conn, "index.json", promocodes: promocodes)
  end

  def all_active_Promocodes(conn, _params) do
    promocodes = EventsPromocode.list_active_promocodes()
    render(conn, "index.json", promocodes: promocodes)
  end

 def events_promocode(conn, %{"event_id" => event_id}) do
   # if is_number(event_id) do
     promocodes = EventsPromocode.list_events_promocode(event_id)
     render(conn, "index.json", promocodes: promocodes)
   # else
   #   json(conn, %{errors: %{detail: "Requires a number as input!"}})
   # end
 end

 def events_active_promocode(conn, %{"event_id" => event_id}) do

   # if is_number(event_id) do
     promocodes = EventsPromocode.list_events_active_promocode(event_id)
     render(conn, "index.json", promocodes: promocodes)
   # else
   #   json(conn, %{errors: %{detail: "Requires a number as input!"}})
   # end
 end

  def create(conn, %{"promocode" => promocode_params}) do
    create_promocode(conn, promocode_params)
  end

  def create_promocode(conn, promocode_params) do

    valid_input = Promocode.promocode_Changeset %Promocode{}, promocode_params
Logger.info "link_insertion: #{inspect(promocode_params)}"
Logger.info "link_insertion: #{inspect(valid_input)}"
    if valid_input.valid? == false do
      json(conn, %{errors: %{detail: PromocodeWeb.ChangesetView.translate_errors(valid_input)}})
    else

      Logger.info "1"
      case EventsPromocode.get_event(promocode_params["event_id"]) do
        %Event{} = event ->

          events_promocode_worth = EventsPromocode.all_events_promocode_worth event.id
          events_remaining_worth = Decimal.to_float(event.event_worth) - events_promocode_worth
          Logger.info "2"
          if promocode_params["promo_code_worth"] < events_remaining_worth do

            case EventsPromocode.create_promocode(promocode_params) do
              {:ok, %Promocode{} = promocode} ->
                conn
                |> put_status(:created)
                |> put_resp_header("location", Routes.promocode_path(conn, :show, promocode))
                |> render("show.json", promocode: promocode)
              {:error, %Ecto.Changeset{} = changeset} ->
                conn
                |> put_status(:bad_request)
                |> json(%{errors: %{detail: PromocodeWeb.ChangesetView.translate_errors(changeset)}})
              _ ->
                json(conn, %{errors: %{detail: "Sorry we are working on this"}})
            end

          else
            json(conn, %{errors: %{detail: "Promocode is exceeding the events worth"}})
          end

        nil ->
          json(conn, %{errors: %{detail: "No event found!"}})
      end

    end
  end

  def show(conn, %{"id" => id}) do
      promocode = EventsPromocode.get_promocode(id)
      render(conn, "show.json", promocode: promocode)
  end

  def display_promocode_by_promo_code_tag(conn, %{"promo_code_tag" => promo_code_tag}) do
      promocode = EventsPromocode.get_promocode_by_promo_code_tag(promo_code_tag)
      render(conn, "show.json", promocode: promocode)
  end

  def update(conn, %{"id" => id, "promocode" => promocode_params}) do
    promocode = EventsPromocode.get_promocode(id)

    with {:ok, %Promocode{} = promocode} <- EventsPromocode.update_promocode(promocode, promocode_params) do
      render(conn, "show.json", promocode: promocode)
    end
  end

  def deactivate_Promocode(conn, %{"promo_code_tag" => promo_code_tag}) do
    case EventsPromocode.get_promocode_by_promo_code_tag(promo_code_tag) do
      %Promocode{} = promocode ->

        case EventsPromocode.update_promocode(promocode, %{is_active: false}) do
          {:ok, %Promocode{} = promocode} ->
            render(conn, "show.json", promocode: promocode)
          _ ->
            json(conn, %{errors: %{detail: "Sorry we are working on this."}})
        end

      nil ->
        json(conn, %{errors: %{detail: "No promocode found!"}})
    end

  end

  def delete(conn, %{"id" => id}) do
    promocode = EventsPromocode.get_promocode!(id)

    with {:ok, %Promocode{}} <- EventsPromocode.delete_promocode(promocode) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_promocode_validity(conn, %{"promo_code_tag" => promo_code_tag, "promocode" => promocode_params}) do
    # Logger.info "link_insertion: #{inspect(link_insertion)}"
    valid_input = Promocodevalidation.changeset %Promocodevalidation{}, promocode_params
    if valid_input.valid? == false do
      json(conn, %{errors: %{detail: PromocodeWeb.ChangesetView.translate_errors(valid_input)}})
    else

      case EventsPromocode.get_promocode_by_promo_code_tag(promo_code_tag) do
        %Promocode{} = promocode ->
          event_location = get_event_location_as_array promocode
          radius = promocode_params["radius_in_km"] * 1000

          case extract_arrays_for_destination_origin(promocode_params) do
            [origin_array, destination_array] ->
              case check_distance(event_location, origin_array, destination_array, radius) do
                {:ok, return_polyline} ->
                  json(conn, %{ok: %{polyline: return_polyline, promocode: make_response_body(promocode)}})


                {:error, error_message} ->
                  json(conn, %{errors: %{detail: error_message}})
              end
            {:error, error_message} ->
              json(conn, %{errors: %{detail: error_message}})
          end
        nil ->
          json(conn, %{errors: %{detail: "No promocode found!"}})
      end

      # json(conn, %{ok: %{detail: "Success :)"}})

    end
  end

  def make_response_body(%Promocode{} = promocode) do
    %{id: promocode.id,
      promo_code_tag: promocode.promo_code_tag,
      is_active: promocode.is_active,
      in_use: promocode.in_use,
      expiry_date: promocode.expiry_date,
      promo_code_worth: promocode.promo_code_worth,
      event_name: promocode.event.event_name,
      event_longitude: promocode.event.event_longitude,
      event_latitude: promocode.event.event_latitude}
  end

  def check_distance(event_location, origin_array, destination_array, radius) do
    calculator = Distance.GreatCircle

    distance1 = calculator.distance event_location, origin_array
    distance2 = calculator.distance event_location, destination_array

    if distance1 <= radius or distance2 <= radius do
      return_polyline = Polyline.encode [origin_array, destination_array]
      {:ok, return_polyline}
    else
      {:error, "Too far from event"}
    end
  end

  def extract_arrays_for_destination_origin(promocode_params) do
    origin = get_location_as_array(promocode_params, "origin")
    destination = get_location_as_array(promocode_params, "destination")

    case origin do
      {:ok, origin_array} ->
        case destination do
          {:ok, destination_array} ->
            [origin_array, destination_array]

          {:error, error_message} ->
            {:error, error_message}
        end
      {:error, error_message} ->
        {:error, error_message}
    end
  end
  defp get_event_location_as_array(%Promocode{} = promocode) do
    event_longitude = promocode.event.event_longitude
    event_latitude = promocode.event.event_latitude
    {event_longitude, event_latitude}
  end

  defp get_location_as_array(promocode_params, param) do
    location = promocode_params[param]
    if length(location) == 2 do
      [longitude | [latitude]] = location
      {:ok, {longitude, latitude}}
    else
      {:error, "Invalid " <> location <> " Format. [longitude, latitude]"}
    end
  end

end
