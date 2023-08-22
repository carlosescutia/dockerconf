#!/bin/bash
#
# fixseq.sh
# fixes nextvalues of all tables from sequences (postgre's autoincrement)
# Carlos Escutia
# last modified: 18/08/23 dd/mm/yy
#

host="localhost"
usr="${POSTGRES_USER}"
db="${POSTGRES_DB}"

# Generate table list

tablas=`psql -h $host -U $usr -c "SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema' order by tablename;" | grep public | awk '{ print $2}' FS="|" | sed -e 's/\ //g'`

for nom_tabla in ${tablas[*]} ; do
    nom_id=`psql -h $host -U $usr -c "\d $nom_tabla" | grep nextval | awk '{ print $1}' FS="|" | sed -e 's/\ //g'`
    
    if [ ! -z "$nom_id" ] ; then
        echo $nom_tabla - $nom_id
        psql -h $host -U $usr -d $db -c "select setval(pg_get_serial_sequence('$nom_tabla', '$nom_id'), (select max($nom_id) from $nom_tabla))" 
    fi
done
