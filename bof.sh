#!/bin/sh

FAIL_COLOR='\033[31m'
MESSAGE_COLOR='\033[34;1m'  # bold blue
NUMBER_COLOR='\033[32m'
WHITE='\033[0m'


parse_line () {
  echo "$1" | sed 's/^.*"\([^"]*\)".*line \([0-9][0-9]*\).*characters \([0-9][0-9]*\)-\([0-9][0-9]*\).*$/\1 \2 \3 \4/'
}

underline () {
  b="$1"
  e="$2"
  printf '%*s' "$b" ' '
  printf "%b" "$FAIL_COLOR"
  printf '%*s\n' "$((e - b))" ' ' | tr ' ' '^'
  printf "%b" "$WHITE"
}

# line -> start_hl -> end_hl -> line
highlight_slice () {
  hl_line="$1"
  start_hl="$2"
  end_hl="$3"

  if [ 0 != "$start_hl" ]; then
    printf '%s' "$(echo "$hl_line" | cut -c"1-$((start_hl - 1))")"
  fi
  printf '%b%s%b' "$FAIL_COLOR" "$(echo "$hl_line" | cut -c"$start_hl-$end_hl")" "$WHITE"
  if [ "$end_hl" != "$((${#hl_line}))" ]; then
    printf '%s' "$(echo "$hl_line" | cut -c"$((end_hl + 1))-$((${#hl_line}))")"
  fi
  printf '\n'
}

# filename -> line number -> line
file_get_line () {
  tail -n+"$2" "$1" | head -n1
}

extract () {
  filename="$1"
  line_number="$2"
  b="$3"
  e="$4"
  offset=2
  start=$((line_number - offset))
  end=$((line_number + offset))
  if [ ! -e "$filename" ]; then
    filename="$(ocamlc -where)/$filename"
  fi
  for i in $(seq "$start" "$end"); do
    printf '%b%d%b:' "$NUMBER_COLOR" "$i" "$WHITE"
    line="$(file_get_line "$filename" "$i")"
    if [ "$i" = "$line_number" ]; then
      highlight_slice "$line" "$b" "$e"
    else
      echo "$line"
    fi
  done
}

read -r line
while read -r line; do
  printf '%b%s%b\n' "$MESSAGE_COLOR" "$line" "$WHITE"
  info="$(parse_line "$line")"
  filename="$(echo "$info" | cut -d' ' -f1)"
  line="$(echo "$info" | cut -d' ' -f2)"
  b="$(echo "$info" | cut -d' ' -f3)"
  e="$(echo "$info" | cut -d' ' -f4)"
  extract "$filename" "$line" "$b" "$e"
  echo
done
