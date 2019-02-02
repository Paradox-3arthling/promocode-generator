defmodule Promocode.Repo do
  use Ecto.Repo,
    otp_app: :promocode,
    adapter: Ecto.Adapters.MySQL
end
