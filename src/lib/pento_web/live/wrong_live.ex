defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, time: time(), message: "Make a guess:")}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's <%= @time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} > <%= n %> </a>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}=data, socket) do
    time = time()
    message = "Your guess: #{guess}. Wrong. Guess again. "
    score = socket.assigns.score - 1

    {
      :noreply,
      assign(
        socket,
        time: time,
        message: message,
        score: score)}
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end

end
