#!/bin/sh
#
# macro-index-generator.sh
#
# Run this script from its directory to generate the complete macro list
#

{
	echo '_Not Autotools_ Macro Index'
	echo '==========================='
	echo
	echo 'This is the complete list of macros released by the **Not Autotools** project.'
	(cd .. && find 'm4' -type f -name '*.m4' -print0) | sort -z | while IFS= read -r -d $'\0' __file__; do
		echo
		echo
		echo "## [\`${__file__}\`](${__file__})"
		echo
		(cd .. && grep -oPHn '(?<=^dnl  )\w+\(\)?' "${__file__}") | \
			sed 's/()$//g;s/($/()/g;s,\([^:]\+\):\([^:]\+\):\([^(]\+\(()\)\?\)$,* [`\3`](\1#L\2),g'
	done
	echo
} > ../macro-index.md

echo 'File ../macro-index.md has been updated.'
