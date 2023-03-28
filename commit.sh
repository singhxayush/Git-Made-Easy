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



#################! SEARCHING FOR FILES UNSTAGED FILES TO STAGE(ADD) #################
unstaged_and_untracked=$(git status --short | grep -v '?? \.' | grep '^ M\|^?? ')
unstaged_and_untracked=$(echo "$unstaged_and_untracked" | sed 's/?? /U->/' | sed 's/ M /M->/')
tracked_files=$(git status --short | grep '^M \|^MM \|^A ' | cut -c4-)



#################! ADDING THE FILES TO BE COMMITED #################
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
        echo ""

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
        # echo "$files_to_stage"
        if [ -z "$files_to_stage" ]
            then
                reset_screen
                echo $(text_color3 " Nothing selected")
                exit
            else
                reset_screen
                counter=1
                echo $files_to_stage | tr " " "\n" | while read line
                do
                    echo "  file$counter : $(text_color3 $line)"
                    counter=$(($counter+1))
                    git add $line
                done
                echo " has been $(text_color2 "added") & ready to $(text_color2 "Commit")"
                echo ""
        fi
fi





echo $(text_color1 " Select staged files to commit!")
gum style --faint " press A to select all or space to select individually then press enter"
tracked_files=$(git status --short | grep '^M \|^MM \|^A ' | cut -c4-)
echo $tracked_files

echo $tracked_files | git commit -m "x"
# files_to_stage=$(echo "$files_to_commit" | cut -c4-)
exit
























































if [ -z "$files_to_commit" ]
then
    echo $(text_color3 " Nothing selected")
    exit
else
fi

tracked_files=$(git status --short | grep '^M ')



#################! UPDATE MESSAGE ################# 
DESCRIPTION=$(gum write --placeholder "Enter your commit message... (CTRL+D to finish)")



#################! COMMIT & PUSH #################
gum confirm "Commit changes & Push?" && (git commit -m "$DESCRIPTION" && git push)


