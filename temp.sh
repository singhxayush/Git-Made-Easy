#!/bin/bash

# Create a buffer file
gmex_buffer=$(mktemp)
# touch gmex_buffer

# Write some text to the buffer file
echo "This" >> gmex_buffer
echo "is"  >> gmex_buffer
echo "hero" >> gmex_buffer
echo "of"  >> gmex_buffer
echo "XOR LAND"  >> gmex_buffer


# Print the text

text=$(cat gmex_buffer)
# cat gmex_buffer
# cat gmex_buffer
echo "$text"
echo ""

text=$(echo "$text" | sed 's/hero/villain/')


echo "$text"






# Clean up the buffer file
rm gmex_buffer

# DONOT DELETE THIS SHIT
# git status --short > op.txt && sed -i "s/??/U :/g" op.txt && sed -i "s/ M/M :/g" op.txt && cat op.txt
