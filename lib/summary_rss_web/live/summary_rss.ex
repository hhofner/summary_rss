defmodule SummaryRssWeb.SummaryRss do
  import Phoenix.HTML.Form
  alias SummaryRss.Youtube
  use SummaryRssWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(
        socket,
        form: to_form(%{url: ""})
      )

    {:ok, socket}
  end

  def handle_event("find", %{"url" => url}, socket) do
    channel_id = Youtube.get_channel_id(url)
    IO.puts("got : #{channel_id}")
    channel_videos = Youtube.get_channel_videos(channel_id)
    IO.inspect(channel_videos)
    %{"videoId" => videoId} = List.first(channel_videos)

    {:ok, captions} =
      YoutubeCaptions.get_subtitles(videoId, "en", receive_timeout: 10_000)

    total_caption =
      Enum.reduce(
        captions,
        "",
        fn x, acc ->
          %{text: text} = x
          acc <> " " <> text
        end
      )

    IO.inspect(total_caption)

    response = OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      messages: [
        %{role: "system", content: "You are a helpful assistant who summarizes Youtube videos based on their captions.
        You summarize it short and concise so its easy and quick to read and understand.
        "},
        %{role: "user", content: "Please summarize the following video from #{url} based on these captions '#{total_caption}'"},
      ]
    )

    IO.inspect(response)

    {:noreply, socket}
  end
end
