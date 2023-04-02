#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

# Read the CSV file line by line
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert the winner team into the teams table if it does not already exist
  if [[ $WINNER != "winner" ]]
  then
    echo $($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
  fi

  # Insert the opponent team into the teams table if it does not already exist
  if [[ $OPPONENT != "opponent" ]]
  then
    echo $($PSQL "INSERT INTO teams (name) SELECT ('$OPPONENT') WHERE NOT EXISTS (SELECT name FROM teams WHERE name = '$OPPONENT');")
  fi

done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert the winner team into the teams table if it does not already exist
  if [[ $YEAR != "year" ]]
  then
    echo $($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ('$YEAR','$ROUND',(SELECT team_id FROM teams WHERE name ='$WINNER'),(SELECT team_id FROM teams WHERE name ='$OPPONENT'),$WINNER_GOALS,$OPPONENT_GOALS)")
  fi


done