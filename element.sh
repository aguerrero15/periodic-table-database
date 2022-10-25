#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

PRINT_INFO() {
  if [[ -z $1 ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$1" | while read NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
    do
      echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
}

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type from elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  PRINT_INFO "$ELEMENT_INFO"
else
  if [[ ${#1} -le 2 ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type from elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
    PRINT_INFO "$ELEMENT_INFO"
  else
    ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type from elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")
    PRINT_INFO "$ELEMENT_INFO"
  fi
fi

