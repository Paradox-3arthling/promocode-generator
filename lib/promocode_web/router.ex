defmodule PromocodeWeb.Router do
  use PromocodeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PromocodeWeb do
    pipe_through :api
       resources "/events", EventController, except: [:new, :edit]

       post "/promocodes/validate/:promo_code_tag", PromocodeController, :check_promocode_validity

       get "/promocodes/tag/:promo_code_tag", PromocodeController, :display_promocode_by_promo_code_tag
       get "/promocodes/active", PromocodeController, :all_active_Promocodes
       get "/promocodes/active/:event_id", PromocodeController, :events_active_promocode
       get "/promocodes/event/:event_id", PromocodeController, :events_promocode
       get "/promocodes/deactivate/:promo_code_tag", PromocodeController, :deactivate_Promocode
       resources "/promocodes", PromocodeController, except: [:new, :edit]
  end
end
