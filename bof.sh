#!/bin/sh

FAIL_COLOR='\033[31m'
MESSAGE_COLOR='\033[34;1m'  # bold blue
WHITE='\033[0m'


parse_line () {
  echo "$1" | sed 's/^.*"\([^"]*\)".*line \([0-9][0-9]*\).*characters \([0-9][0-9]*\)-\([0-9][0-9]*\).*$/\1 \2 \3 \4/'
}

underline () {
  b="$1"
  e="$2"
  printf '%*s' "$b" ' '
  printf "%b" "$FAIL_COLOR"
  printf '%*s' "$((e - b))" ' ' | tr ' ' '^'
  printf "%b" "$WHITE"
}

extract () {
  offset=1
  filename="$1"
  line="$2"
  if [ ! -e "$filename" ]; then
    filename="$(ocamlc -where)/$filename"
  fi
  tail -n+"$((line - offset))" "$filename" | head -n"$((1 + offset))"
  underline "$3" "$4"
}

read -r line
while read -r line; do
  echo -e "$MESSAGE_COLOR$line$WHITE"
  info="$(parse_line "$line")"
  extract $info
  echo
done
