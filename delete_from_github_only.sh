#!/bin/bash

# create 
mkdir .gmextempdir
touch .gitignore

echo "Select files to delete"


# select files and move
files_to_delete=$(ls -t)
files_to_delete=$(gum choose --no-limit $files_to_delete)
echo "$files_to_delete" >> .gitignore
mv $files_to_delete .gmextempdir

# commit the removed change
git add $files_to_delete
git commit -m "deleted files"
git push

# move back
mv .gmextempdir/* .
rmdir .gmextempdir/