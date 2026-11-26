
#!/bin/bash

# Conexion con PostgreSQL
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Comprobar si se ha introducido un argumento
if [ -z "$1" ]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Buscar el elemento por numero atomico, simbolo o nombre
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name = '$1' LIMIT 1")

# Comprobar si el elemento existe
if [ -z "$ATOMIC_NUMBER" ]
then
  echo "I could not find that element in the database."
  exit 0
fi

# Obtener todas las propiedades del elemento
ELEMENT_DATA=$($PSQL "SELECT e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $ATOMIC_NUMBER")

# Separar los datos obtenidos
IFS='|' read -r NAME SYMBOL TYPE MASS MELTING BOILING <<EOF
$ELEMENT_DATA
EOF

# Mostrar la informacion del elemento
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
