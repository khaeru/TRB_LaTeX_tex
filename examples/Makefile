export TEXINPUTS:=..:${TEXINPUTS}
export BSTINPUTS:=..:${BSTINPUTS}

all: biblatex.pdf default.pdf

clean:
	latexmk -C biblatex default

%.pdf: %.tex
	latexmk -pdf -silent -pdflatex="pdflatex -shell-escape %O %S" $<

.PHONY: clean
