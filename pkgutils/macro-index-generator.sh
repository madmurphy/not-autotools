#!/bin/sh
#
# macro-index-generator.sh
#
# Run this script to generate the complete macro list
#

{
	echo '_Not Autotools_ Macro Index'
	echo '==========================='
	echo
	echo 'This is the complete list of all the macros released by the **Not Autotools**'
	echo 'project.'
	(cd .. && find 'm4' -type f -exec printf '\n\n## `%s`\n\n' '{}' ';' \
		-exec grep -oPHn '(?<=^dnl  )\w+\(' '{}' ';') | \
		sed 's,\([^:]\+\):\([^:]\+\):\([^(]\+\)($,* [\3()](\1#L\2),g'
	echo
} > ../macro-index.md

