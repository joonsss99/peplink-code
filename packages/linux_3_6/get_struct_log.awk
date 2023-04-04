#!/usr/bin/awk -f

BEGIN {
	is_struct_log = 0;
}

/^struct[[:space:]]log/ {
	is_struct_log = 1;
}

{
	if (is_struct_log == 1) {
		sub(/u64/,"__u64",$0)
		sub(/u32/,"__u32",$0)
		sub(/u16/,"__u16",$0)
		sub(/u8/,"__u8",$0)
		print
	}
}

/^};/ {
	if (is_struct_log == 1) {
		is_struct_log = 0;
	}
}
