#!/bin/bash

# Separator to visually distinguish between default scopes and filenames
#SEPARATOR='"------"'

# Get the list of changed files
CHANGED_FILES=$(git diff --name-only HEAD)

# Extract filenames from the list of changed files
NEW_SCOPES=$(echo "$CHANGED_FILES" | xargs -n1 basename | sort | uniq | jq -R . | jq -s -c .)

# Read the default scopes
DEFAULT_SCOPES=$(cat /home/mindriddler/.config/czg/defaultscopes.json)

# Combine the new scopes, separator, and default scopes
COMBINED_SCOPES=$(jq -n --argjson new "$NEW_SCOPES" --argjson def "$DEFAULT_SCOPES" \
  '[$def[], "──────────────", $new[]]')

# Update cz.json with the combined scopes using jq
jq ".scopes = $COMBINED_SCOPES" /home/mindriddler/.config/czg/cz.json > /home/mindriddler/.config/czg/cz_temp.json && mv /home/mindriddler/.config/czg/cz_temp.json /home/mindriddler/.config/czg/cz.json
