demo:
	ocamlopt -g -o test test.ml && OCAMLRUNPARAM=b ./test 2>&1 | ./byob

clean:
	rm -f *.cm[iox] *.o test
