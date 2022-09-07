defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}
  alias Pento.Accounts

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        _target: generate_random_number(),
        score: 0,
        time: time(),
        message: "Make a guess (1-10):",
        session_id: session["live_socket_id"],
      )
    }
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
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}=data, socket) do
    time = time()
    target = socket.assigns._target

    message = if guess == target do
      "Your guess: #{guess}. Correct. A new target has been generated, guess again? "
    else
      "Your guess: #{guess}. Wrong. Guess again. "
    end

    target = if guess == target do
      generate_random_number()
    else
      target
    end

    score = if guess == target do
      socket.assigns.score + 1
    else
      socket.assigns.score - 1
    end


    {
      :noreply,
      assign(
        socket,
        _target: target,
        time: time,
        message: message,
        score: score)}
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end

  def generate_random_number() do
    :rand.uniform(10) |> to_string()
  end

end
