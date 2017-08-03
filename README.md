# LaTeX class for TRB Annual Meeting papers

The [Transportation Research Board of the U.S. National Academies](http://trb.org) in its [Information for Authors](http://onlinepubs.trb.org/onlinepubs/AM/InfoForAuthors.pdf), gives detailed requirements for papers submitted for the TRB Annual Meeting and for publication in *Transportation Research Record*. `trbunofficial.cls` is a LaTeX class that allows preparation of LaTeX documents meeting these requirements, with minimal adjustments to standard LaTeX code.

Also included are:
- `trb.bst` — a BibTeX style file.
- `trb.bbx`, `trb.cbx` — bibliography and citation (respectively) style files for `biblatex`.

## Usage and features

See the files in the `examples` directory:
- `default.tex` — an example with default class settings, using [`natbib`](http://ctan.org/pkg/natbib) for citations and the bibliography → produces [`default.pdf`](./tree/master/examples/default.pdf).
- `biblatex.tex` — an example using [`biblatex`](https://ctan.org/pkg/biblatex) for citations and the bibilography.

### Class options
```
% (first line of LaTeX document)
\documentclass[options]{trbunofficial}
```

The available options are:
- `natbib` (default) or `biblatex` — use the specified package for citations and the bibliography.
- `numbered` — number lines.
- `compat` (default) or `nocompat` — aim for slavish compliance with the features of the Information for Authors that are clearly aimed at users of Microsoft Word. This currently has the following effects:
  - Blank lines are numbered on the title page between the title, authors, word count and date.

### Document preamble

- Give the `\title{…}`.
- Format the `\author{…}` block as in the example files. Also, use `\AuthorHeaders{…}` to set the author surnames in the page header.
- (`biblatex` only) Use `\addbibresource{…}` at least once to add bibilography sources.
- (optional) The word count on the title page is calculated automatically. To set the total words manually and avoid automatic word counting, use `\setcounter{textwords}{4500}` (where 4500 is the number of words).

### Document body

- Issue `\maketitle` as the first command after `\begin{document}`.
- Format the abstract and keywords as in the example files.
- Caption tables in [Title Case](https://en.wikipedia.org/wiki/Letter_case#Title_case), and figures in  [Sentence case](https://en.wikipedia.org/wiki/Letter_case#Sentence_case).
- Cite references:
  - for `biblatex`: use the standard commands.
  - for `natbib`: use the provided `\trbcite{…}` command. See `examples/default.tex`.
- At the end of the document, set the bibilography on a new page:
  - for `natbib`:
    ```
    \newpage
    \bibliographystyle{trb}
    \bibliography{…}
    ```
  - for `biblatex`:
    ```
    \newpage
    \printbibliography
    ```

### Compiling

The word-counting feature invokes [`texcount`](http://app.uio.no/ifi/texcount/) at the time the document is compiled. This requires the `-shell-escape` option to the LaTeX compiler (e.g., `pdflatex`) in order to permit it to invoke other programs. If `texcount` was *not* installed with a TeX distribution (e.g. [TeX Live!](https://www.tug.org/texlive/) or [MikTeX](https://miktex.org/)) then a Perl interpreter (e.g. [ActivePerl](http://www.activestate.com/activeperl/downloads)) may also be required.

To avoid these requirements, count words by some other method and set the counter manually, as described above.

- Using plain `pdflatex`:
  ```
  pdflatex -shell-escape document.tex
  ```
- Using `latexmk`:
  ```
  latexmk -pdf -pdflatex="pdflatex -shell-escape %O %S" document.tex
  ```
- In TeXStudio ([source](http://tex.stackexchange.com/questions/233511/inkscape-and-shell-escape-with-texstudio)):
  - Go to *Options* → *Configure TeXStudio*.
  - Click on *Commands*.
  - Add the `-shell-escape` flag to ``pdflatex``:
    ```
    pdflatex.exe -synctex=1 -interaction=nonstopmode -shell-escape %.tex
    ```
- On [Overleaf](http://overleaf.com), `-shell-escape` is enabled by default.

## About

This is a lighter version of the former TRB LaTeX
[template](https://github.com/chiehrosswang/TRB_LaTeX_rnw). The previous
version was built primarily for people using R, Sweave, and LaTeX. Therefore,
this version is created for people who need a straight-forward LaTeX template
for TRB papers.
