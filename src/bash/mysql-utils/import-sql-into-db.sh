#!/bin/bash
# Purpose: Import data from sql file to mysql db.
# Author : Roberto Desideri http://robdesideri.it
# Usage  : ./import-sql-into-db user password dbname dir/foo/db.sql
# Usage  : ./import-sql-into-db user password dbname dir/foo/db.sql hostname
# Version: 1.0

MUSER="$1"
MPASS="$2"
MDB="$3"
MSQLFILE="$4"

MHOST="localhost"

[ "$5" != "" ] && MHOST="$5"

# detect paths
MYSQL=$(type -p mysql)

# parameters checking
if [ ! $# -ge 4 ]
then
	echo "Usage: $0 {MySQL-User-Name} {MySQL-User-Password} {MySQL-Database-Name} {SQL-Dump-File-Path} [host-name]"
	echo "Import data from sql file to mysql db."
	exit 1
fi

# server connection checking
if ! $MYSQL -u "$MUSER" -p"$MPASS" -h "$MHOST" -e "use $MDB"  &>/dev/null
then
	echo "Error - Cannot connect to mysql server using given username, password or database does not exits!"
	exit 2
fi

# check sql file exits
if [ ! -f "$MSQLFILE" ]
then
	echo "$MSQLFILE not found."
  exit 2
fi

# import data
$MYSQL -u "$MUSER" -p"$MPASS" -h "$MHOST" "$MDB" < "$MSQLFILE"