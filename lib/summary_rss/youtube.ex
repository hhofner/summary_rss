defmodule SummaryRss.Youtube do
  # defines methods to:
  # 1. get the channel ID of a youtube channel
  # 2. get the last 20 videos of a youtube channel
  # 3. get the transcriptions of a youtube video
  @channels_url "https://youtube.googleapis.com/youtube/v3/channels"
  @search_url "https://youtube.googleapis.com/youtube/v3/search"

  def get_channel_id(handle) do
    case HTTPoison.get(
           @channels_url,
           [],
           params: %{
             part: "snippet",
             forHandle: handle,
             key: System.get_env("YOUTUBE_API_KEY")
           }
         ) do
      {:ok, response} ->
        items = response.body |> Jason.decode!() |> Map.get("items")
        items |> List.first() |> Map.get("id")

      {:error, _error} ->
        "error"
    end
  end

  def get_channel_videos(channel_id) do
    case HTTPoison.get(
           @search_url,
           [],
           params: %{
             part: "snippet",
             maxResults: 10,
             key: System.get_env("YOUTUBE_API_KEY"),
             channelId: channel_id
           }
         ) do
      {:ok, response} ->
        IO.inspect(response)
        items = response.body |> Jason.decode!() |> Map.get("items")
        Enum.map(items, fn item -> Map.get(item, "id") end)

      {:error, error} ->
        "error"
    end
  end
end
