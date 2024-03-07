defmodule SummaryRss.Openai do
  def get_video_summary(captions, channel_id) do
    OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      messages: [
        %{
          role: "system",
          content:
            "You are a helpful assistant who summarizes Youtube videos based on their captions.
        You summarize it short and concise so its easy and quick to read and understand.
        "
        },
        %{
          role: "user",
          content:
            "Please summarize the following video from #{channel_id} based on these captions '#{captions}'"
        }
      ]
    )
  end
end
