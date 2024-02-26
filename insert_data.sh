#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner && $OPPONENT != opponent ]]
then
    WINNER_EXISTS=$($PSQL "select count(*) from teams where name='$WINNER'")
    OPPONENT_EXISTS=$($PSQL "select count(*) from teams where name='$OPPONENT'")
    if [[ $WINNER_EXISTS -eq 0 ]]
    then
      $PSQL "INSERT INTO teams (name) VALUES ('$WINNER')"
    fi
    if [[ $OPPONENT_EXISTS -eq 0 ]]
    then
      $PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')"
    fi
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -n $WINNER_ID && -n $OPPONENT_ID ]]
    then
      $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
    fi
  fi
done