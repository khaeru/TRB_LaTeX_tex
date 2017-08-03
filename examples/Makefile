export TEXINPUTS:=..:${TEXINPUTS}
export BSTINPUTS:=..:${BSTINPUTS}

all: default.pdf

clean:
	latexmk -C default

%.pdf: %.tex
	latexmk -pdf -silent -pdflatex="pdflatex -shell-escape %O %S" $<

.PHONY: clean
