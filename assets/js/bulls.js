import React, { useState, useEffect } from 'react';
import { ch_join, ch_push, ch_reset } from './socket';
import '../css/app.css';

// Displayed if the player loses
function YouLost({reset}) {
    return (
        <div className="App">
            <div className="container">
                <h1>Loser!</h1>
                <p>
                    <button onClick={reset}>
                        New Game
                    </button>
                </p>
            </div>
        </div>
    );
}

// Displayed if the player wins
function YouWon({reset}) {
    return (
        <div className="App">
            <div className="container">
                <h1>Congrats! You Won! :)</h1>
                <p>
                    <button onClick={reset}>
                        New Game
                    </button>
                </p>
            </div>
        </div>
    );
}

function Bulls() {

    // Game state
    const [state, setState] = useState({
        guesses: [],
        dispError: "", 
        results: [],
        gameOver: false
    })

    let {guesses, dispError, results, gameOver} = state;

    // Control state for input
    const [number, setNumber] = useState("");

    let indices = [1, 2, 3, 4, 5, 6, 7, 8];

    useEffect(() => {
        ch_join(setState);
    });

    // verifies valid guess and then updates game state based on a user guess
    function guess(number) {
        console.log("Guess: " + number);
        ch_push({g: number})
        setNumber("");
    }

    // resets game state to starting state
    function newGame() {
        console.log("Reset");
        setNumber("");
        ch_reset();
    }

    //mostly from "updateText" in lecture notes for Hangman
    function updateNumber(ev) {
        let val = ev.target.value;
        if (val.length > 4) {
            val = val.slice(0, 4);
        }
        setNumber(val);
    }

    // From lecture notes for Hangman
    function keyUp(ev) {
        if (ev.key === "Enter") {
            guess(number);
        }
    }

    // If the use has won, change the displayed component
    if (gameOver) {
        return <YouWon reset={newGame}/>;
    }

    // From lecture notes for Hangman
    if (guesses.length >= 8) {
        return <YouLost reset={newGame}/>
    }

    return (
        <div className="App">
            <div className="container">
                <div className="centered">
                <h1>4Digit Game!</h1><br/>
                <p>
                    <button onClick={newGame}>New Game</button>
                    <br/><br/>
                </p>
                <div >
                    <p>Try to guess the secret code! Make a guess, you have eight tries to figure it out!</p>
                    <p>Bulls are right numbers in the right place. Cows are right numbers in the wrong place.</p>
                    <br/><br/>
                </div>

        </div>
                <div className="row">
                    <div className="col-sm-4"></div>
                    <div className="col">
                        <p>Enter 4 digits to make a guess:</p>
                        <input type="text" value={number} onChange={updateNumber} onKeyUp={keyUp}/>
                        <button className="btn-info" onClick={() => guess(number)}>Guess!</button>
                        <p>{dispError}</p>
                    </div>
                    <div className="col-sm-1">
                        <div className="new-line">
                            {indices.join(":\n")}
                        </div>
                    </div>
                    <div className="col-sm-1">
                        <div className="new-line">
                            {guesses.join("\n")}
                        </div>
                    </div>
                    <div className="col-sm-2">
                        <div className="new-line">
                            {results.join('\n')}
                        </div>
                    </div>
                </div>
            </div>
        </div>

    );
}

export default Bulls;