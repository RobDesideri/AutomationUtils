#!/bin/bash
# Purpose: Backup entire MySql db by dump into sql file.
# Author : Roberto Desideri http://robdesideri.it
# Usage  : ./backup-mysql-db user password dbname dir/foo/db.sql
# Usage  : ./backup-mysql-db user password dbname dir/foo/db.sql hostname
# Version: 1.0

MUSER="$1"
MPASS="$2"
MDB="$3"
BKPATH="$4"

MHOST="localhost"

[ "$5" != "" ] && MHOST="$5"

# detect paths
MYSQLDUMP=$(type -p mysqldump)
TAR=$(type -p tar)
RM=$(type -p rm)

# parameters checking
if [ ! $# -eq 5 ]
then
	echo "Usage: $0 {MySQL-User-Name} {MySQL-User-Password} {MySQL-Database-Name} {Backup-Dir-Path} [host-name]"
	echo "Backup entire MySql db by dump into sql file."
	exit 1
fi

# server connection checking
if ! $MYSQL -u "$MUSER" -p"$MPASS" -h "$MHOST" -e "use $MDB"  &>/dev/null
then
	echo "Error - Cannot connect to mysql server using given username, password or database does not exits!"
	exit 2
fi

# build filename time based
TIME=$(date +%b-%d-%y-%s)
FILENAME=bk-$TIME.sql

# check dir exists
if [ ! -d "$BKPATH" ]
then
  $MKDIR "$BKPATH"
fi

# Dump db
$MYSQLDUMP "$MDB" -u "$MUSER" -p"$MPASS" -r "$BKPATH/$FILENAME"

# Archive data and remove dump
$TAR -cpzf "$DESDIR/$FILENAME.tar.gz" "$DESDIR/$FILENAME"
$RM -f "$DESDIR/$FILENAME"