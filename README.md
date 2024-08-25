# Guess the Number Game

## Overview

This smart contract implements a simple "Guess the Number" game on the Aptos blockchain. Players can bet APT coins and try to guess a randomly generated number between 1 and 10. If they guess correctly, they win double their bet; otherwise, they lose their bet.

## Contract Details

- **Module Name**: `guess_number_game`
- **Address**: `game` (replace with actual address after deployment)

## Game Rules

1. The game generates a random number between 1 and 10.
2. Players must bet 0.1 APT to make a guess.
3. If the player's guess matches the secret number, they win double their bet.
4. If the player's guess is incorrect, they lose their bet.
5. Only one game can be active at a time.

## Functions

### `start_game`

Starts a new game by generating a random secret number.

```
public entry fun start_game(account: &signer)
- **Parameters**:
  - `account`: The signer starting the game.
- **Errors**:
  - `E_GAME_IN_PROGRESS`: Thrown if a game is already in progress.
```

### `make_guess`

Allows a player to make a guess and place a bet.



```
public entry fun make_guess(player: &signer, guess: u64)

- **Parameters**:
  - `player`: The signer making the guess.
  - `guess`: The player's guess (must be between 1 and 10).
- **Errors**:
  - `E_GAME_IN_PROGRESS`: Thrown if no game is currently active.
  - `E_INVALID_GUESS`: Thrown if the guess is not between 1 and 10.
  - `E_INSUFFICIENT_BALANCE`: Thrown if the player doesn't have enough APT to place the bet.
```

### `is_game_in_progress`

View function to check if a game is currently in progress.

```
#[view]
public fun is_game_in_progress(): bool
- **Returns**: `true` if a game is in progress, `false` otherwise.
```
## Constants

- `MIN_NUMBER`: 1 (Minimum possible secret number)
- `MAX_NUMBER`: 10 (Maximum possible secret number)
- `BET_AMOUNT`: 10,000,000 octas (0.1 APT)

## Error Codes

- `E_INSUFFICIENT_BALANCE`: 1 (Player doesn't have enough APT to bet)
- `E_INVALID_GUESS`: 2 (Guess is not between 1 and 10)
- `E_GAME_IN_PROGRESS`: 3 (Attempting to start a new game while one is in progress)

## Usage

1. Deploy the module to your account on the Aptos blockchain.
2. Call `start_game` to begin a new game.
3. Call `make_guess` with your guess (between 1 and 10) to play. Ensure you have at least 0.1 APT in your account.
4. Check the result of your guess by monitoring your APT balance.
5. Use `is_game_in_progress` to check if a game is currently active before starting a new one.

## Security Considerations

- The contract uses Aptos' built-in randomness module, which provides secure, unpredictable random numbers.
- Players should be aware that they can lose their bet if they guess incorrectly.
- The contract owner should ensure proper access control if additional administrative functions are added in the future.

## Disclaimer

This game involves betting with real APT coins. Players should be aware of the risks involved in gambling and play responsibly.