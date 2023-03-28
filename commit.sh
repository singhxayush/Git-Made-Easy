#!/bin/bash

#! CLEARS THE SCREEN BEFORE STARING - UNCOMMENT THIS IF YOU DON'T LIKE
clear

#################! STYLING AND DECLARATIONS #################
print_banner() {
    gum style \
    --border rounded  \
    --border-foreground="#66b3ff" \
    --bold \
    --width=3 \
    --padding="0 4" \
    "Commit Your Changes 🚀"
}
print_banner

reset_screen() {
    clear
    print_banner
}

# bold pink
text_color1() {
    text=$1
    gum style --bold --foreground "#ff3399" "$text"
}

# bold red
text_color2() {
    text=$1
    gum style --bold --foreground "#ff0000" "$text"
}

# light green
text_color3() {
    text=$1
    gum style --foreground "#33cc33" "$text"
}

# light yellow
text_color4() {
    text=$1
    gum style --foreground "#FFF829" "$text"
}



#################! SEARCHING FOR FILES UNSTAGED FILES TO STAGE(ADD) #################
unstaged_and_untracked=$(git status --short | grep -v '?? \.' | grep '^ M\|^?? ')
unstaged_and_untracked=$(echo "$unstaged_and_untracked" | sed 's/?? /U->/' | sed 's/ M /M->/')
tracked_files=$(git status --short | grep '^M \|^MM \|^A ' | cut -c4-)



#################! STAGING FILES #################
if [ -z "$unstaged_and_untracked" ]
    then
        if [ -z "$tracked_files" ]
            then
            echo $(text_color3 " No changes were made")
            exit
        fi

    else
        echo $(text_color1 " Select files to stage!")
        gum style --faint " press A to select all or space to select individually then press enter"
        gum style --faint " M -> Modified U -> Untracked"

        files_to_stage=$(
            gum choose \
            --cursor="▶ " \
            --cursor.foreground="988AFF" \
            --selected.foreground="#FFF829" \
            --cursor-prefix="❰ ❱ " \
            --selected-prefix="❰✘❱ " \
            --no-limit $unstaged_and_untracked
        )

        files_to_stage=$(echo "$files_to_stage" | cut -c4-)

        if [ -z "$files_to_stage" ]
            then
                reset_screen
            else
                reset_screen
                counter=1
                echo $files_to_stage | tr " " "\n" | while read line
                do
                    echo "  file$counter : $(text_color3 $line)"
                    counter=$(($counter+1))
                    git add $line
                done
                echo " has been $(text_color2 "Staged") & ready to $(text_color2 "Commit")"
                echo ""
        fi
fi



#################! SELECT STAGED TO COMMIT #################
tracked_files=$(git status --short | grep '^M \|^MM \|^A ' | cut -c4-)
if [ -z $tracked_files ]
    then
    echo $(text_color3 " Noting staged")
    exit
fi

echo $(text_color1 " Select staged files to commit locally!")
gum style --faint " press A to select all or space to select individually then press enter"

files_to_commit=$(
    gum choose \
    --cursor="▶ " \
    --cursor.foreground="988AFF" \
    --selected.foreground="#FFF829" \
    --cursor-prefix="❰ ❱ " \
    --selected-prefix="❰✘❱ " \
    --no-limit $tracked_files
)
echo $files_to_commit
if [ -z "$files_to_commit" ]
    then
    reset_screen
    echo $(text_color3 " Nothing selected")
    exit
fi

#################! UPDATE MESSAGE ################# 
DESCRIPTION=$(gum write --placeholder "$(text_color3 "Enter your  message... (CTRL+D to finish)")")

exit
echo $tracked_files | git commit -m "$DESCRIPTION"



tracked_files=$(git status --short | grep '^M ')






#################! PUSH LOCAL COMMITS #################
gum confirm "Push?" && (git commit -m "$DESCRIPTION" && git push)


