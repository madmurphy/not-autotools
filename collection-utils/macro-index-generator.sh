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
	echo 'This is the complete list of macros released by the **Not Autotools** project.'
	(cd .. && find 'm4' -type f -name '*.m4' -printf '\n\n## [`%p`](%p)\n\n' \
		-exec grep -oPHn '(?<=^dnl  )\w+\(\)?' '{}' ';') | \
		sed 's/()$//g;s/($/()/g;s,\([^:]\+\):\([^:]\+\):\([^(]\+\(()\)\?\)$,* [`\3`](\1#L\2),g'
	echo
} > ../macro-index.md

