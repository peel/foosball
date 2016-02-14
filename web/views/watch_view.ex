#---
# Excerpted from "Programming Phoenix",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/phoenix for more book information.
#---
defmodule Rumbl.WatchView do
  use Rumbl.Web, :view

  def player_id(video) do
    ~r/^.*(?:youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)(?<id>[^#\&\?]*).*/
    |> Regex.named_captures(video.url)
    |> get_in(["id"])
  end
end