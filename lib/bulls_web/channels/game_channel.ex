defmodule BullsWeb.GameChannel do 
    use BullsWeb, :channel 

    alias Bulls.Game
    alias Bulls.BackupAgent

    # largely from hangman lecture notes
    @impl true
    def join("game:" <> name, payload, socket) do
        if authorized?(payload) do
            game = Game.new
            socket = socket
            |> assign(:name, name)
            |> assign(:game, game)
            {:ok, socket}
        else
            {:error, %{reason: "unauthorized"}}
        end
    end

    # largely from hangman lecture notes
    @impl true
    def handle_in("guess", %{"g" => gg}, socket0) do
        game0 = socket0.assigns[:game]
        game1 = Game.guess(game0, gg)
        socket1 = assign(socket0, :game, game1)
        view = Game.view(game1)
        {:reply, {:ok, view}, socket1}
    end

    # largely from hangman lecture notes
    @impl true
    def handle_in("reset", _, socket) do
        game = Game.new
        socket = assign(socket, :game, game)
        view = Game.view(game)
        {:reply, {:ok, view}, socket}
    end

    # Add authorization logic here as required.
    # directly from lecture notes
    defp authorized?(_payload) do
        true
    end
end
