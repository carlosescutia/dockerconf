#!/bin/bash
#
# csv2tbl.sh
# imports csv files into tables
# and fixes nextvalues from sequences (postgre's autoincrement)
# Carlos Escutia
# last modified: 18/08/23 dd/mm/yy
#

host="localhost"
usr="${POSTGRES_USER}"
db="${POSTGRES_DB}"
currdir=`pwd`

# csv2tbl
# -------
for tabla in $(ls *.csv) ; do 
    echo ${tabla/.csv/}
    psql -h $host -U $usr -d $db -c "TRUNCATE ${tabla/.csv/} RESTART IDENTITY;" 
    psql -h $host -U $usr -d $db -c "\copy ${tabla/.csv/} FROM '$currdir/$tabla' USING DELIMITERS ',' CSV HEADER ;" 
done

# fixseq only on imported tables
# ------------------------------
for tabla in $(ls *.csv) ; do 
    nom_tabla=${tabla/.csv/}
    nom_id=`psql -h $host -U $usr -c "\d $nom_tabla" | grep nextval | awk '{ print $1}' FS="|" | sed -e 's/\ //g'`
    
    if [ ! -z "$nom_id" ] ; then
        echo $nom_tabla - $nom_id
        psql -h $host -U $usr -d $db -c "select setval(pg_get_serial_sequence('$nom_tabla', '$nom_id'), (select max($nom_id) from $nom_tabla))" 
    fi
done
