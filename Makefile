all:
	ocamlopt -g -o a.out test.ml && OCAMLRUNPARAM=b ./a.out 2>&1 | sh bof.sh

clean:
	rm -f *.cm[iox] *.o a.out
