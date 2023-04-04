#!/usr/bin/awk -f

# generate true inittab from command file

BEGIN {
	FS = ":" ;
	OFS = ":";
	num_add_cmd = 0;
}

$1 ~ /add/ {
	# look for repeated command
	for (i = 0; i < num_add_cmd; i++)
		if (add_cmd[i] == $3) {
			break
		}
	if (i >= num_add_cmd) {
		# new command
		add_cmd[i] = $3
		add_cmd_type[i] = $2
		num_add_cmd++;
	}
}

$1 ~ /del/ {
	for (i = 0; i < num_add_cmd; i++)
		if (add_cmd[i] == $3) {
			add_cmd_type[i] = "delete"
		}
}
$1 ~ /login/ {
	login_tty = $2
	login_cmd = $3
}

END {

	for (i = 0; i < num_add_cmd; i++) {
		if (add_cmd_type[i] == "delete")
			continue
		sub(/\|/ , ":" ,add_cmd[i])
		print "null", "", add_cmd_type[i], add_cmd[i]
	}

	print login_tty, "", "respawn", login_cmd
}

