#!/bin/bash


#################! STYLING AND DECLARATIONS #################
print_banner() {
    clear
    gum style \
    --border rounded  \
    --border-foreground="#66b3ff" \
    --bold \
    --width=3 \
    --padding="0 4" \
    "Commit Your Changes 🚀"
}

print_banner

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



#################! SEARCHING FOR FILES UNSTAGED & UNTRACKED FILES TO STAGE(ADD) #################
unstaged_and_untracked=$(git status --short | grep -v '?? \.' | grep '^ M\|^?? \|^MM ')
unstaged_and_untracked=$(echo "$unstaged_and_untracked" | sed 's/?? /U->/' | sed 's/ M /M->/' | sed 's/MM /M->/')
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
        gum style --faint " M -> Modified | U -> Untracked"
        gum style --faint " -------------------------------------------------"

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
                print_banner
            else
                print_banner
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



#################! SELECT STAGED FILES TO COMMIT #################
tracked_files=$(git status --short | grep '^M \|^MM \|^A ' | cut -c4-)
if [ -z $tracked_files ]
    then
    echo $(text_color3 " Nothing staged")
    exit
fi

echo $(text_color1 " Select staged files to commit locally!")
gum style --faint " press A to select all or space to select individually then press enter"
gum style --faint " -------------------------------------------------"

files_to_commit=$(
    gum choose \
    --cursor="▶ " \
    --cursor.foreground="988AFF" \
    --selected.foreground="#FFF829" \
    --cursor-prefix="❰ ❱ " \
    --selected-prefix="❰✘❱ " \
    --no-limit $tracked_files
)

if [ -z "$files_to_commit" ]
    then
    print_banner
    echo $(text_color3 " Nothing selected")
    exit
fi



#################! UPDATE MESSAGE ################# 
print_banner
echo $(text_color1 " Write an Update message")
gum style --faint " -------------------------------------------------"
DESCRIPTION=$(gum write --placeholder "Enter update message here... (CTRL+D to finish)")



#################! PUSH LOCAL COMMITS #################
print_banner
gum confirm $(text_color2 "Push?") && ((echo $tracked_files | git commit -m "$DESCRIPTION") && git push)



clear
gum style --border rounded --border-foreground="#b3f759" --bold --width=1 --padding="0 3" "DONE!";

