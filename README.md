# Beautify Your Ocaml Backtraces

`byob` is a shell script that makes OCaml backtraces prettier… or at least
tries to do so!

## Usage

TL;DR `ocamlc -g test.ml -o test && OCAMLRUNPARAM=b ./test 2>&1 | ./byob`

1. Compile the OCaml program with debugging information (`ocamlc/ocamlopt -g`)
2. Enable backtraces with the environment variable: `OCAMLRUNPARAM=b`
3. Pipe the stderr of the crashing program into `byob`

## Features

- Print a small portion of the files where the exceptions are raised
- Use colors

and that's pretty much it for the moment
