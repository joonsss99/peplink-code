#!/usr/bin/awk -f

BEGIN { FS=":" }

$1 ~ /dir/ { print "[ -d", $2, "] || mkdir", $2 }
$1 ~ /link/ { print "ln -nsf", $2, $3 }


