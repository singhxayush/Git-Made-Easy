#!/bin/bash

#! CLEARS THE SCREEN BEFORE STARING - UNCOMMENT THIS IF YOU DONT LIKE
clear

#################! STYLING AND DECLARATIONS #################
gum style \
    --border rounded  \
    --border-foreground="#66b3ff" \
    --bold \
    --width=3 \
    --padding="0 4" \
    "Commit Your Changes 🚀"

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

























#################! SEARCHING FOR FILES UNSTAGED FILES TO STAGE(ADD) #################
# temp=$(git status --short | grep '^U :\|^M \|^ M')
unstaged_and_untracked=$(git status --short | grep -v '?? \.' | grep '^ M\|^?? ')


# grep '^ M\|^A\|^D' | cut -c4-

# creating a buffer file to operate sed commands



echo "$unstaged_and_untracked"
echo ""

unstaged_and_untracked=$(echo "$unstaged_and_untracked" | sed 's/??/U :/' | sed 's/ M/M :/')


echo "$unstaged_and_untracked"















































exit
gum style --faint " press A to select all or space to select individually then press enter"
gum style --faint " M -> Modified"
gum style --faint " U -> Untracked"


if [ -z "$temp" ]
then
    echo $(text_color3 " No changes were made")
    exit
fi



#################! ADDING THE FILES TO BE COMMITED #################

files_to_commit=$(
    gum choose \
    --cursor="▶ " \
    --cursor.foreground="988AFF" \
    --selected.foreground="#FFF829" \
    --cursor-prefix="❰ ❱ " \
    --selected-prefix="❰✘❱ " \
    --no-limit $temp
)


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
    echo "has been $(text_color2 "added") & ready to $(text_color2 "Commit")"
fi
echo ""



#################! UPDATE MESSAGE ################# 
DESCRIPTION=$(gum write --placeholder "Enter your commit message... (CTRL+D to finish)")



#################! COMMIT & PUSH #################
gum confirm "Commit changes & Push?" && (git commit -m "$DESCRIPTION" && git push)


