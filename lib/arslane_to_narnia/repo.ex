defmodule ArslaneToNarnia.Repo do
  use Ecto.Repo,
    otp_app: :arslane_to_narnia,
    adapter: Ecto.Adapters.Postgres
end
