#!/usr/bin/env bash
set -euo pipefail

toml_write() {
  local FILE
  local KEY
  local VALUE

  FILE=${1:-"new.toml"}
  KEY=${2:-}
  VALUE=${3:-}

  KEYGROUP=$(echo "$KEY" | awk 'BEGIN{FS=OFS="."}{NF--; print}')
  NAME=$(echo "$KEY" | awk -F\. '{print $NF}')

  if ! [[ "$VALUE" =~ \[.*\] ]] && [[ -n "$VALUE" ]] ; then
    VALUE="\"$VALUE\""
  fi

  touch "$FILE"

  if [[ -n "$VALUE" ]] ; then
    if [[ -z "$KEYGROUP" ]] ; then
      echo -e "$NAME = $VALUE" >> "$FILE"
    else
      if grep -q "$KEYGROUP" "$FILE"; then
        sudo sed -i '/\['"$KEYGROUP"'\]/a \\t'"$NAME"' = '"$VALUE"'' "$FILE"
      else
        echo -e "[$KEYGROUP]\n\t$NAME = $VALUE" >> "$FILE"
      fi
    fi
  else
    if [[ -z "$KEYGROUP" ]] ; then
      echo -e "[$NAME]" >> "$FILE"
    else
      if grep -q "$KEYGROUP" "$FILE"; then
        sudo sed -i '/\['"$KEYGROUP"'\]/a \\t\['"$KEYGROUP"'.'"$NAME"'\]' "$FILE"
      else
        echo -e "[$KEYGROUP.$NAME]" >> "$FILE"
      fi
    fi
  fi
}