HTMLDIR=/home/zeus/httpd/html/texts
HTMLDIR_LAB=/home/zeus/httpd/html/lab/texts
LATEX2HTML=latex2html -split +1
LATEXMK=latexmk
#LATEX2HTML=hevea
HEVEA=hevea
CP=cp -dRuv
.SUFFIXES: .md .pdf .tex .dvi

paper.pdf: paper.md
presen.pdf: presen.md
C: C.dvi C.pdf C.html
unix: unix.dvi unix.pdf unix.html
unix-lesson: unix-lesson.dvi unix-lesson.pdf unix-lesson.html
install: install.pdf install.html

clean:
	rm -f *.aux *.log *.bbl *.blg *.toc *.dvi *~ *.fdb_latexmk *.fls *.synctex.gz *-md.tex

all: paper presen math-lesson C unix unix-lesson install

.SUFFIXES: .tex .pdf

.tex.pdf:
	platex $<
	platex $<
	platex $<
	dvipdfmx $<

.md.pdf:
	bin/md2tex $<
	${LATEXMK} $*-md.tex
#	platex $*-md.tex
#	platex $*-md.tex
#	dvipdfmx $*-md.dvi
	mv $*-md.pdf $*.pdf
