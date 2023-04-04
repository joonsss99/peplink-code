#!/usr/bin/awk -f

# parse the already created inittab into commands

BEGIN { FS = ":" ; OFS = ":"}
/^null/ { print "add", $3, $4 (NF~5 ? "|"$5:"") }
$1 !~ /^null/ { print "login", $1, $4 }

