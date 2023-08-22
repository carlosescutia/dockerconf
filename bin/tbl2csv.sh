#!/bin/bash
#
# tbl2csv.sh
# exports tables from database to csv
# Carlos Escutia
# last modified: 18/08/23 dd/mm/yy
#

host="localhost"
usr="${POSTGRES_USER}"
db="${POSTGRES_DB}"
dst_dir=`pwd`

# Generate table list
tablas=`psql -h $host -U $usr -c "SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema' order by tablename;" | grep public | awk '{ print $2}' FS="|" | sed -e 's/\ //g'`

for tabla in ${tablas[*]} ; do
    psql -h $host -U $usr -d $db -c "\copy (SELECT * FROM $tabla) to '$dst_dir/$tabla.csv' WITH DELIMITER ',' CSV HEADER ;"
done
