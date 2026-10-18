CREATE TABLE IF NOT EXISTS users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS games (
  game_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(user_id),
  number_of_guesses INT NOT NULL
);

CREATE INDEX IF NOT EXISTS games_user_id_idx ON games(user_id);