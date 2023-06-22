#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

GAME() {
  SECRET_NUMBER=$((1 + RANDOM % 1000))

  echo "Guess the secret number between 1 and 1000:"
  read NUMBER

  if [[ $NUMBER =~ ^[0-9]+$ ]]; then
    count=0
    while [[ $NUMBER -ne $SECRET_NUMBER ]]; do
      ((count++))
      if (($NUMBER > $SECRET_NUMBER)); then
        echo "It's lower than that, guess again:"
      else
        echo "It's higher than that, guess again:"
      fi
      read NUMBER
    done
    echo "You guessed it in $count tries. The secret number was $SECRET_NUMBER. Nice job!"
  else
    echo "That is not an integer, guess again:"
    GAME
  fi
}

USERNAME_NAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")


if [[ -z $USERNAME_NAME ]]
 then
  echo "Welcome, $username! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
  GAME
 else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM game JOIN users USING(user_id) WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM game LEFT JOIN users USING(user_id) WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  GAME
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
INSERT_GAME_RESULT=$($PSQL "INSERT INTO game(user_id, number_of_guesses, games_played) VALUES ($USER_ID, $count, $GAMES_PLAYED)")
