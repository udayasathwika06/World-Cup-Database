#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Insert unique teams into the teams table
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    for team in "$winner" "$opponent"
    do
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$team'")
      if [[ -z $TEAM_ID ]]
      then
        INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$team')")
        echo "$INSERT_TEAM_RESULT"
      fi
    done
  fi
done < games.csv

# Insert games into the games table
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
    VALUES($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
    echo "$INSERT_GAME_RESULT"
  fi
done < games.csv