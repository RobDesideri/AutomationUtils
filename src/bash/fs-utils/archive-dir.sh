#!/bin/bash
# Purpose: Archive entire directory to tar.gz file.
# Author : Roberto Desideri http://robdesideri.it
# Usage  : ./archive-dir dir/foo bk/foo foobk
# Version: 1.0

SOURCEDIR="$1"
DESTDIR="$2"
DESTFILENAME="$3"

# detect paths
MKDIR=$(type -p mkdir)
TAR=$(type -p tar)

# parameters checking
if [ ! $# -eq 3 ]
then
	echo "Usage: $0 {Source-Dir-Path} {Backup-Dir-Path}"
	echo "Archive entire directory to tar.gz file."
	exit 1
fi

# build filename time based
TIME=$(date +%b-%d-%y-%s)
FILENAME=bk-$TIME-$DESTFILENAME.tar.gz

# check dir exists
if [ ! -d "$DESTDIR" ]
then
  $MKDIR "$DESTDIR"
fi

# archive htdocs in bk file
$TAR -cpzf "$DESTDIR/$FILENAME" "$SOURCEDIR"