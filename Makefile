LATEXMK=latexmk
.SUFFIXES: .md .pdf .tex .dvi

HTMLDIR=${HOME}/mnt/web/public_html/download/texts/

paper.pdf: paper.md
presen.pdf: presen.md
C: C.dvi C.pdf C.html
unix.pdf: unix.md
unix-lesson.pdf: unix-lesson.md

clean:
	rm -f *.aux *.log *.bbl *.blg *.toc *.dvi *~ *.fdb_latexmk *.fls *.synctex.gz *-md.tex

all: paper presen math-lesson C unix unix-lesson install

.SUFFIXES: .tex .pdf

install:
	install paper.pdf presen.pdf unix.pdf unix-lesson.pdf C.pdf C-lesson.pdf ${HTMLDIR}

.tex.pdf:
	platex $<
	platex $<
	platex $<
	dvipdfmx $<

.md.pdf:
	./bin/md2tex $<
	${LATEXMK} $*-md.tex
#	platex $*-md.tex
#	platex $*-md.tex
#	dvipdfmx $*-md.dvi
	mv $*-md.pdf $*.pdf
