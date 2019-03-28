clear

echo "Alte Datenbanken löschen..."
rm db/development.sqlite3
rm db/test.sqlite3

echo "Neue Datenbanken erstellen..."
RAILS_ENV=development rake db:migrate >/dev/null
# RAILS_ENV=test        rake db:migrate >/dev/null

if [ $? -eq 0 ]; then
echo "----------------------------------------------------"
echo "Das neue Schema:"
sqlite3 db/development.sqlite3 -batch .schema | grep TABLE
echo "----------------------------------------------------"
echo "Indizes:"
sqlite3 db/development.sqlite3 -batch .schema | grep INDEX

RAILS_ENV=development rake db:seed
cp db/development.sqlite3 db/test.sqlite3

RAILS_ENV=development
fi
