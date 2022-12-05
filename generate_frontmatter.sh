#!/bin/sh

LOCATION=$(pwd);

echo
echo "Starting frontmatter generation for dir = $LOCATION"
echo

find . -name "*.md" -print0 | xargs -0 -I file ./prepend.sh file

echo
echo "Finished frontmatter generation for dir = $LOCATION"
echo