\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{trbunofficial}[2017/08/03 TRB latex template]

% Option declarations
\newif\if@biblatex\@biblatexfalse
\DeclareOption{natbib}{}
\DeclareOption{biblatex}{
  \@biblatextrue
}

\newif\if@numbered\@numberedfalse
\DeclareOption{numbered}{
  \@numberedtrue
}

\newif\if@trbcompat\@trbcompattrue
\DeclareOption{nocompat}{
  \@trbcompatfalse
}

\ProcessOptions\relax

% Load the parent class
\LoadClass[12pt,oneside,titlepage]{article}

% Variables
\def\@AuthorHeaders{Name1, Name2 and Name3}
\newcommand{\AuthorHeaders}[1]{
  \def\@AuthorHeaders{#1}
}

% General formatting
% Paragraph indent: 0.5 inches
\setlength{\parindent}{0.5in}

% geometry: Page layout
\RequirePackage{geometry}
\geometry{
  textwidth = 6.5in,
  textheight = 9.0in,
  top = 1in,
  left = 1in,
  headheight = 0.3in,
  headsep = 0.2in,
  }

% mathptmx: Times New Roman-like fonts for math and body text
\RequirePackage{mathptmx}
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}

% titlesec: Page style and headings
\RequirePackage[tiny, rm, pagestyles]{titlesec}
% Page headers
\newpagestyle{main}{
\sethead{\@AuthorHeaders}{}{\thepage}
}
\pagestyle{main}
% Line spacing: 12pt before section titles
\titleformat{\section}{\bfseries}{}{0pt}{\uppercase}
\titlespacing*{\section}{0pt}{12pt}{*0}
\titleformat{\subsection}{\bfseries}{}{0pt}{}
\titlespacing*{\subsection}{0pt}{12pt}{*0}
\titleformat{\subsubsection}{\itshape}{}{0pt}{}
\titlespacing*{\subsubsection}{0pt}{12pt}{*0}

% amsmath: Equations
\RequirePackage[fleqn]{amsmath}
\setlength{\mathindent}{0in}
% Set spacing before and after equation to be 0
\g@addto@macro\normalsize{%
  \setlength\abovedisplayskip{0pt}
  \setlength\belowdisplayskip{0pt}
  \setlength\abovedisplayshortskip{0pt}
  \setlength\belowdisplayshortskip{0pt}
}

% enumitem: Lists
% Adjust lists a little. Not quite perfectly fitting TRB style, but vaguely
% close at least.
\RequirePackage{enumitem}
\setlist[1]{labelindent=0.5in,leftmargin=*}
\setlist[2]{labelindent=0in,leftmargin=*}
% Eliminate extra vertical spacing between items
\setlist{nosep}

% ccaption: Captions
% Get the captions right. Authors must still be careful to use "Title Case"
% for table captions, and "Sentence case." for figure captions.
\RequirePackage{ccaption}
\renewcommand{\fnum@figure}{\bfseries FIGURE~\thefigure}
\renewcommand{\fnum@table}{\bfseries TABLE~\thetable}
\captiontitlefont{\bfseries \boldmath}
\captiondelim{\;}
%\precaption{\boldmath}

% biblatex or natbib: Citations.
% TRB uses an Author (num) citation style.
\if@biblatex  % bibliography using biblatex
\RequirePackage[style=trb]{biblatex}

\else  % bibliography using natbib
\RequirePackage[sort&compress,numbers]{natbib}
% I haven't found a way to make LaTeX/Bibtex do this automatically using the
% standard \cite macro, but this modified \trbcite macro does the trick.
\renewcommand{\cite}[1]{(\textit{\citenum{#1}})}
\newcommand{\trbcite}[1]{\citeauthor{#1} (\textit{\citenum{#1}})}
\renewcommand*{\refname}{\uppercase{References}}
\setcitestyle{round}
% Reduce spacing between bibliographic items
\setlength{\bibsep}{0pt plus 0.3ex}
\fi

% lineno: Line numbering
\if@numbered
\RequirePackage[pagewise, mathlines]{lineno}
% Adjust the font of the line numbering
\renewcommand\linenumberfont{\normalfont\small}
\linenumbers
\fi


% Word counting
%
% TRB requires the total number of words, figures, and tables to be displayed
% on the title page. Since v2.1, we:
% - count the words in the body text and bibliography using the 'texcount'
%   utility that comes with most TeX distributions,
% - count the number of tables and figures, and
% - compute a total wordcount.
%
% The user can:
% - Use \setcounter{textwords}{1234} in the preamble to avoid use of texcount.
% - Override the word equivalents for figures and tables. The defaults are:
%   \setcounter{wordsperfigure}{250}
%   \setcounter{wordspertable}{250}

% catchfile: for \CatchFileDef
\RequirePackage{catchfile}

% totcount: for counters
\RequirePackage{totcount}

% Number of words in body text and bibliography
\newcounter{textwords}

% Total words including word equivalents of tables and figures
\newcounter{totalwords}

% Word equivalents for figures and tables
\newcounter{wordsperfigure}
\setcounter{wordsperfigure}{250}
\newcounter{wordspertable}
\setcounter{wordspertable}{250}

% Number of tables
\regtotcounter{table}

% Number of figures
\regtotcounter{figure}

% Count text words
\newcommand{\trb@countwords}{
  % Invoke texcount to count words for the entire document, incl. bibliography
  \immediate\write18{texcount -sum -1 -incbib -out=\jobname.count \jobname.tex}
  % Read the word count and set textwrods
  \CatchFileDef{\@textwords}{\jobname.count}{}
  \setcounter{textwords}{\@textwords}
}

% Compute total words
\newcommand{\trb@totalwords}{
  \setcounter{totalwords}{\value{textwords}}%
  \addtocounter{totalwords}{\numexpr\value{wordsperfigure}*\totvalue{figure}}%
  \addtocounter{totalwords}{\numexpr\value{wordspertable}*\totvalue{table}}%
}

% Print out the word count
\newcommand{\printwordcount}{
  Word Count: \arabic{textwords} words + %
  \total{figure} figure\ifnum\totvalue{figure}=1\else s\fi %
  $\times$ \arabic{wordsperfigure} + %
  \total{table} table\ifnum\totvalue{table}=1\else s\fi %
  $\times$ \arabic{wordspertable} %
  = \arabic{totalwords} words
}

\AtBeginDocument{
  % Don't count words if the user has \setcounter{textwords}{…}
  \ifnum\thetextwords=0
    \trb@countwords
  \fi
  \trb@totalwords
}

% Title page
% TODO use 'titling' package instead, which provides similar features
\newcommand{\trb@posttitle}{\vspace{3\baselineskip}}
\newcommand{\trb@postauthor}{\vspace{2\baselineskip}}
\newcommand{\trb@postwordcount}{\vfill}
\newcommand{\trb@postdate}{\vfill}

\if@trbcompat
  \renewcommand{\trb@posttitle}{
    \hfill\break%
    \hfill\break%
    \hfill\break%
  }
  \renewcommand{\trb@postauthor}{
    \hfill\break%
    \hfill\break%
  }
  \renewcommand{\trb@postwordcount}{
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
    \hfill\break%
  }
  \renewcommand{\trb@postdate}{}
\fi

\renewcommand{\maketitle}{%
  \thispagestyle{empty}
  \begin{flushleft}
    {\MakeUppercase{\bfseries\@title}}\\
    \trb@posttitle
    \@author\\
    \trb@postauthor
    \printwordcount
    \trb@postwordcount
    Submission Date: \@date
    \trb@postdate
  \end{flushleft}
\newpage
}

\endinput
