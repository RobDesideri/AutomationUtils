#!/bin/bash
# Purpose: Drop all tables from MySQL database.
# Author : Roberto Desideri http://robdesideri.it
# Usage  : ./empty-mysql-db.sh user password dbname
# Usage  : ./empty-mysql-db.sh user password dbname hostname
# Credits: http://www.cyberciti.biz/faq/how-do-i-empty-mysql-database/
# Version: 1.0

MUSER="$1"
MPASS="$2"
MDB="$3"

MHOST="localhost"

[ "$4" != "" ] && MHOST="$4"

# detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)

# parameters checking
if [ ! $# -ge 3 ]
then
	echo "Usage: $0 {MySQL-User-Name} {MySQL-User-Password} {MySQL-Database-Name} [host-name]"
	echo "Drop all tables from MySQL database."
	exit 1
fi

# server connection checking
if ! "$MYSQL" -u "$MUSER" -p"$MPASS" -h "$MHOST" -e "use $MDB"  &>/dev/null
then
	echo "Error - Cannot connect to mysql server using given username, password or database does not exits!"
	exit 2
fi

TABLES=$($MYSQL -u "$MUSER" -p"$MPASS" -h "$MHOST" "$MDB" -e 'show tables' | $AWK "{ print $1}" | $GREP -v '^Tables' )

# database tables checking
if [ "$TABLES" == "" ]
then
	echo "Error - No table found in $MDB database!"
	exit 3
fi

# execution
for t in $TABLES
do
	echo "Deleting $t table from $MDB database..."
	"$MYSQL" -u "$MUSER" -p"$MPASS" -h "$MHOST" "$MDB" -e "drop table $t"
done