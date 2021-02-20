defmodule Bulls.Game do 
    @moduledoc """
    Bulls keeps the contexts that define your domain
    and business logic.

    Contexts are also responsible for managing your data, regardless
    if it comes from the database, an external API or others.
    """

    def new do 
        %{
            secret: random_code(),
            guesses: [], 
            results: [],
            gameOver: false,
            dispError: ""
        }
        
    end

    def guess(st, g) do 
        e = get_error(g, st.guesses)
        if (e == "") do 
            %{ st |
                guesses: st.guesses ++ [g],
                results: st.results ++ [get_result(g, st.secret)],
                dispError: e
            }
        else 
            %{st | dispError: e}
        end
    end

    def view(st) do 
        %{
            guesses: st.guesses, 
            results: st.results,
            gameOver: user_win(st),
            dispError: st.dispError
        }
    end

    def random_code() do
        ints = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        |> Enum.shuffle()
        |> Enum.slice(0..3)
        |> Enum.join()
    end

    # based on the guess and the previous guesses, determines whether it is a valid guess, and returns an error if not
    def get_error(g, guesses) do
        if (String.length(g) < 4) do
          "Please input 4 digits"
        else 
            if (!is_numeric(g)) do 
                "Please input a number"
            else 
                if (!digits_unique(g)) do
                "Four digits must be unique"
                else 
                    if (Enum.member?(guesses, g)) do
                    "You already guessed that!"
                    else 
                        ""
                    end
                end
            end
        end
    end
    
    # determined if a string contains only digits
    def is_numeric(str) do 
        digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        (str
        |> String.split("", trim: true)
        |> Enum.filter(fn dd -> Enum.member?(digits, dd) end)
        |> Enum.count()) == 4
    end

    # determines whether or not all the digits in a number are unique
    def digits_unique(x) do
        size = String.length(x)
        (x
        |> String.split("", trim: true)
        |> Enum.uniq()
        |> Enum.count()) == size
    end

    # gets the results of a guess when compared to the code (# of bulls and cows)
    def get_result(guess, code) do
        digits = String.split(code, "", trim: true)
        guess_digits = String.split(guess, "", trim: true)
        bull = get_bulls(guess_digits, digits)
        cow = (guess_digits
        |> Enum.filter(fn gg -> Enum.member?(digits, gg) end)
        |> Enum.count()) - bull
        Enum.join(["Bulls: ", bull, ", Cows: ", cow])
    end

    def get_bulls(guess, code) do 
        if Enum.count(guess) == 1 do
            if hd(guess) == hd(code) do 
                1
            else 
                0
            end
        else 
            if hd(guess) == hd(code) do 
                1 + get_bulls(tl(guess), tl(code))
            else 
                get_bulls(tl(guess), tl(code))
            end
        end
    end 
 
    # has the user won?
    def user_win(st) do
        Enum.member?(st.guesses, st.secret)
    end
end