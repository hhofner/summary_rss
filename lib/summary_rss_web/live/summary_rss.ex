defmodule SummaryRssWeb.SummaryRss do
  import Phoenix.HTML.Form
  alias SummaryRss.Youtube
  use SummaryRssWeb, :live_view

  def mount(_params, _session, socket) do
    socket = 
      assign(
        socket, 
        form: to_form(%{url: ""}))
    {:ok, socket}
  end

  def handle_event("find", %{"url" => url}, socket) do
    text = Youtube.get_channel_id(url)
    IO.puts("got : #{text}")
    {:noreply, socket}
  end
end
