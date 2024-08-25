module game::guess_number_game {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::randomness;

    // Error codes
    const E_INSUFFICIENT_BALANCE: u64 = 1;
    const E_INVALID_GUESS: u64 = 2;
    const E_GAME_IN_PROGRESS: u64 = 3;

    // Game constants
    const MIN_NUMBER: u64 = 1;
    const MAX_NUMBER: u64 = 10;
    const BET_AMOUNT: u64 = 10_000_000; // 0.1 APT

    struct GameState has key {
        secret_number: u64,
        in_progress: bool,
    }

    // Initialize the game
    fun init_module(account: &signer) {
        move_to(account, GameState {
            secret_number: 0,
            in_progress: false,
        });
    }

    // Start a new game
    public entry fun start_game(account: &signer) acquires GameState {
        let game_state = borrow_global_mut<GameState>(@my_addr);
        assert!(!game_state.in_progress, E_GAME_IN_PROGRESS);

        // Generate a random number between MIN_NUMBER and MAX_NUMBER
        game_state.secret_number = randomness::u64_range(MIN_NUMBER, MAX_NUMBER + 1);
        game_state.in_progress = true;
    }

    // Make a guess
    public entry fun make_guess(player: &signer, guess: u64) acquires GameState {
        let player_addr = signer::address_of(player);
        let game_state = borrow_global_mut<GameState>(@my_addr);

        assert!(game_state.in_progress, E_GAME_IN_PROGRESS);
        assert!(guess >= MIN_NUMBER && guess <= MAX_NUMBER, E_INVALID_GUESS);

        // Check if the player has enough balance
        assert!(coin::balance<AptosCoin>(player_addr) >= BET_AMOUNT, E_INSUFFICIENT_BALANCE);

        // Deduct the bet amount from the player
        let bet = coin::withdraw<AptosCoin>(player, BET_AMOUNT);

        if (guess == game_state.secret_number) {
            // Player wins, return double the bet
            let winnings = coin::extract(&mut bet, BET_AMOUNT);
            coin::merge(&mut bet, winnings);
            coin::deposit(player_addr, bet);
        } else {
            // Player loses, bet goes to the contract
            coin::deposit(@my_addr, bet);
        }

        // Reset the game state
        game_state.in_progress = false;
        game_state.secret_number = 0;
    }

    // View function to check if a game is in progress
    #[view]
    public fun is_game_in_progress(): bool acquires GameState {
        borrow_global<GameState>(@my_addr).in_progress
    }
}