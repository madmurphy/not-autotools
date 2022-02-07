#!/bin/bash
#
# strip-comments.sh
#

cd ..
rm -rf undocumented-m4
cp -r m4 undocumented-m4

find 'undocumented-m4' -type f -name '*.m4' \
	-exec sed -i '/^dnl\(\W\|\s*$\)/d' '{}' ';' \
	-exec sed -i -z 's/^\n*//;s/\n\n\+/\n\n\n/g' '{}' ';'

echo 'An undocumented version of this library has been created in'
echo "$(pwd)/undocumented-m4."
