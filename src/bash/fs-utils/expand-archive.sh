#!/bin/bash
# Purpose: Expand archive and overwrite files.
# Author : Roberto Desideri http://robdesideri.it
# Usage  : ./expand-archive archivepath destpath
# Version: 1.0

ARCHIVEPATH="$1"
DESTPATH="$2"

# detect paths
MKDIR=$(type -p mkdir)
TAR=$(type -p tar)
RM=$(type -p rm)

# parameters checking
if [ ! $# -eq 2 ]
then
	echo "Usage: $0 {Archive-File-Path} {Destination-Dir-Path}"
	echo "Expand archive and overwrite files."
	exit 1
fi

# chech archive exists
if [ ! -f "$ARCHIVEPATH" ]
then
	echo "$ARCHIVEPATH archive not exists."
	exit 1
fi

# chech dest exists
if [ ! -d "$DESTPATH" ]
then
  $MKDIR "$DESTPATH"
fi

# remove dest contents
$RM -r "$DESTPATH/*" 2> /dev/null

# expand archive
$TAR -xf "$ARCHIVEPATH" -C "$DESTPATH"