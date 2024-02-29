defmodule SummaryRss.Youtube do
  # defines methods to:
  # 1. get the channel ID of a youtube channel
  # 2. get the last 20 videos of a youtube channel
  # 3. get the transcriptions of a youtube video
  @channels_url "https://youtube.googleapis.com/youtube/v3/channels"
  @videos_url "https://youtube.googleapis.com/youtube/v3/videos"
  @captions_url "https://youtube.googleapis.com/youtube/v3/captions"

  def get_channel_id(handle) do
    url_with_params =
      @channels_url <>
        "?part=snippet&forHandle=" <> handle <> "&key=" <> System.get_env("YOUTUBE_API_KEY")

    case HTTPoison.get(
           url_with_params,
           [{"Accept", "application/json"}]
         ) do
      {:ok, response} ->
        items = response.body |> Jason.decode!() |> Map.get("items")
        items |> List.first() |> Map.get("id")

      {:error, error} ->
        "error"
    end
  end

  def get_channel_videos(channel_id) do
    url_with_params =
      @videos_url <>
        "?part=snippet%2CcontentDetails&id=" <>
        channel_id <> "&maxResults=20&key=" <> System.get_env("YOUTUBE_API_KEY")

    case HTTPoison.get(
           url_with_params,
           [{"Accept", "application/json"}]
         ) do
      {:ok, response} ->
        items = response.body |> Jason.decode!() |> Map.get("items")
        items

      {:error, error} ->
        "error"
    end
  end

  def get_video_captions(video_id) do
    url_with_params =
      @captions_url <>
        "?part=snippet&videoId=" <> video_id <> "&key=" <> System.get_env("YOUTUBE_API_KEY")

    case HTTPoison.get(
           url_with_params,
           [{"Accept", "application/json"}]
         ) do
      {:ok, response} ->
        items = response.body |> Jason.decode!() |> Map.get("items")
        items

      {:error, error} ->
        "error"
    end
  end

  def download_video_caption() do
  end
end
