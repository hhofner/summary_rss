defmodule SummaryRss.Repo do
  use Ecto.Repo,
    otp_app: :summary_rss,
    adapter: Ecto.Adapters.SQLite3
end
