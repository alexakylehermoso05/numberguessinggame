#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read -r USERNAME
SQL_USERNAME=${USERNAME//\'/\'\'}
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$SQL_USERNAME'")

if [[ -z $USER_ID ]]; then
  $PSQL "INSERT INTO users(username) VALUES('$SQL_USERNAME')" > /dev/null
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$SQL_USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$((RANDOM % 1000 + 1))
NUMBER_OF_GUESSES=0

echo "Guess the secret number between 1 and 1000:"
read -r GUESS

while true; do
  ((NUMBER_OF_GUESSES++))

  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    read -r GUESS
    continue
  fi

  GUESS_VALUE=$((10#$GUESS))
  if ((GUESS_VALUE == SECRET_NUMBER)); then
    break
  elif ((GUESS_VALUE < SECRET_NUMBER)); then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi

  read -r GUESS
done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
$PSQL "INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)" > /dev/null