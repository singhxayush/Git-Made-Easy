#!/bin/bash

print_banner() {
    clear
    gum style \
    --border double  \
    --border-foreground="#66b3ff" \
    --bold \
    --width=3 \
    --padding="0 5" \
 "
 GitHub
 Manager
 "
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


gum style --faint " Select an Option"
gum style --faint " -------------------------------------------------"

gum choose \
    --cursor="🞄 " \
    --item.border-background="#FFF829" \
    --item.faint \
    --item.bold \
    'clone a repo' 'initialise new repo' 'delete a repo' 'list all repos'



