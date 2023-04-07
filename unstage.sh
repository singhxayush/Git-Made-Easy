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
    "Unstage Your Changes 💬"
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



#################! SELECT STAGED FILES TO UNSTAGE #################
tracked_files=$(git status --short | grep '^M \|^MM \|^A ' | cut -c4-)

if [ -z "$tracked_files" ]
    then
    echo $(text_color3 " Nothing staged")
    exit
fi

echo $(text_color1 " Select files to unstage")
gum style --faint " press A to select all or space to select individually then press enter"
gum style --faint " -------------------------------------------------"

files_to_unstage=$(
    gum choose \
    --cursor="▶ " \
    --cursor.foreground="988AFF" \
    --selected.foreground="#FFF829" \
    --cursor-prefix="❰ ❱ " \
    --selected-prefix="❰✘❱ " \
    --no-limit $tracked_files
)

if [ -z "$files_to_unstage" ]
    then
    print_banner
    echo $(text_color3 " Nothing selected")
    exit
fi



#################! UNSTAGE #################
git restore --staged $files_to_unstage

clear
gum style --border rounded --border-foreground="#b3f759" --bold --width=1 --padding="0 3" "DONE!";