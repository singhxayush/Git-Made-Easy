#!/bin/bash

# CLEARS THE SCREEN BEFORE STARING - UNCOMMENT THIS IF YOU DONT LIKE
clear


################# STYLING AND DECLARATIONS #################

gum style \
    --border rounded  \
    --border-foreground="#66b3ff" \
    --bold \
    --width=3 \
    --padding="0 3" \
    "Commit Your Changes"

text_color1() {
    text=$1
    gum style --bold --foreground "#ff3399" "$text"
}

text_color2() {
    text=$1
    gum style --bold --foreground "#ff0000" "$text"
}

text_color3() {
    text=$1
    gum style --foreground "#33cc33" "$text"
}



################# SEARCHING FOR FILES TO COMMIT #################

temp=$(git status | grep -oe "\w*.md\b" -e "\w*.cpp\b")

gum style --faint " press A to select all or space to select one or more then press enter"


if [ -z "$temp" ]
then
    echo $(text_color3 " No were changes made")
    exit
fi


################# ADDING THE FILES TO BE COMMITED #################


files_to_commit=$(gum choose --no-limit $temp)

if [ -z "$files_to_commit" ]
then
    echo $(text_color3 " Nothing selected")
    exit
else
    counter=1
    echo $files_to_commit | tr " " "\n" | while read line
    do
        echo "  file$counter : $(text_color3 $line)"
        counter=$(($counter+1))
        git add $line
    done
    git add $files_to_commit
    echo "has been $(text_color2 "added") & ready to $(text_color2 "Commit")"
fi


echo ""


################# UPDATE MESSAGE #################

# Pre-populate the input with the type(scope): so that the user may change it
DESCRIPTION=$(gum write --placeholder "Enter your commit message... (CTRL+D to finish)")


################# COMMIT & PUSH #################
gum confirm "Commit changes & Push?" && git commit -m "$DESCRIPTION" && git push