
# Given a file path as an argument
# 1. get the file name
# 2. prepend template string to the top of the source file
# 3. resave original source file

filepath="$1"
file_name=$(basename $filepath)

# Getting the file name (title)
md='.md'
title=${file_name%$md}

STRING="^---"

if grep -q "$STRING" "$filepath"; then
         echo "[ ] Frontmatter already exists for file $filepath" ;
else
         # Prepend front-matter to files
         TEMPLATE="---
title: $title
description: $title
---
         "

         echo "[+] Added frontmatter to file $filepath" ;
         echo "$TEMPLATE" | cat - "$filepath" > temp && mv temp "$filepath";
fi








