defmodule Promocode.EventsPromocode do
  @moduledoc """
  The EventsPromocode context.
  """

  import Ecto.Query, warn: false
  alias Promocode.Repo

  alias Promocode.EventsPromocode.Event
  alias Promocode.EventsPromocode.Promocode

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  def get_event(id), do: Repo.get(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{source: %Event{}}

  """
  def change_event(%Event{} = event) do
    Event.changeset(event, %{})
  end


  @doc """
  Returns the list of promocodes.

  ## Examples

      iex> list_promocodes()
      [%Promocode{}, ...]

  """
  def list_active_promocodes do
    query = from p in Promocode,
            where: p.is_active == true

    query
    |> Repo.all()
    |> Repo.preload(:event)
  end

  def list_events_active_promocode(event_id) do
    query = from p in Promocode,
            where: p.is_active == true and p.event_id == ^event_id

    query
    |> Repo.all()
    |> Repo.preload(:event)
  end

  def list_events_promocode(event_id) do
    query = from p in Promocode,
            where: p.event_id == ^event_id

    query
    |> Repo.all()
    |> Repo.preload(:event)
  end

  def list_promocodes do
    Promocode
    |> Repo.all()
    |> Repo.preload(:event)
  end

  def all_events_promocode_worth (event_id) do
    query = from p in Promocode,
            where: p.event_id == ^event_id,
            select: sum(p.promo_code_worth)

     case Repo.all(query) do
       [nil] -> 0
       [total] ->
          Decimal.to_float total
     end
  end

  @doc """
  Gets a single promocode.

  Raises `Ecto.NoResultsError` if the Promocode does not exist.

  ## Examples

      iex> get_promocode!(123)
      %Promocode{}

      iex> get_promocode!(456)
      ** (Ecto.NoResultsError)

  """
  def get_promocode!(id), do: Repo.get!(Promocode, id)

  def get_promocode(id) do
    Promocode
    |> Repo.get(id)
    |> Repo.preload(:event)
  end

  def get_promocode_by_promo_code_tag(promo_code_tag) do
    Promocode
    |> Repo.get_by(promo_code_tag: promo_code_tag)
    |> Repo.preload(:event)
  end

  @doc """
  Creates a promocode.

  ## Examples

      iex> create_promocode(%{field: value})
      {:ok, %Promocode{}}

      iex> create_promocode(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_promocode(attrs \\ %{}) do
    # %Promocode{}
    # |> Promocode.changeset(attrs)
    # |> Repo.insert()
    promocode_changeset = Promocode.promocode_Changeset(%Promocode{}, attrs)
    is_promocode_changeset_valid = promocode_changeset.valid?
    case is_promocode_changeset_valid do
      true ->
        case Repo.insert(promocode_changeset) do
          {:ok, %Promocode{} = promocode} ->
            {:ok, Repo.preload(promocode, :event)}
          {:error, %Ecto.Changeset{} = promocode} ->
            {:error, promocode}
        end

      false ->
        promocode_changeset
        |> Repo.insert()
    end
  end

  @doc """
  Updates a promocode.

  ## Examples

      iex> update_promocode(promocode, %{field: new_value})
      {:ok, %Promocode{}}

      iex> update_promocode(promocode, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_promocode(%Promocode{} = promocode, attrs) do
    promocode
    |> Promocode.changeset(attrs)
    |> Repo.update()
  end

  def update_promocode_is_active(%Promocode{} = promocode, attrs) do
    promocode
    |> Promocode.is_active_Changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Promocode.

  ## Examples

      iex> delete_promocode(promocode)
      {:ok, %Promocode{}}

      iex> delete_promocode(promocode)
      {:error, %Ecto.Changeset{}}

  """
  def delete_promocode(%Promocode{} = promocode) do
    Repo.delete(promocode)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking promocode changes.

  ## Examples

      iex> change_promocode(promocode)
      %Ecto.Changeset{source: %Promocode{}}

  """
  def change_promocode(%Promocode{} = promocode) do
    Promocode.changeset(promocode, %{})
  end
end
