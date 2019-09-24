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

# filename -> line number -> line
file_get_line () {
  tail -n+"$2" "$1" | head -n1
}

extract () {
  filename="$1"
  line_number="$2"
  offset=2
  start=$((line_number - offset))
  end=$((line_number + offset))
  if [ ! -e "$filename" ]; then
    filename="$(ocamlc -where)/$filename"
  fi
  for i in $(seq "$start" "$end"); do
    printf '%b%d%b:' "$NUMBER_COLOR" "$i" "$WHITE"
    file_get_line "$filename" "$i"
    if [ "$i" = "$line_number" ]; then
      printf '%*s' $((${#i} + 1)) ' '
      underline "$b" "$e"
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
