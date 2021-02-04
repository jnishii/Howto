LATEXMK=latexmk
.SUFFIXES: .md .pdf .tex .dvi

HTMLDIR=${HOME}/mnt/zeus/jun/public_html/custom/download/texts/

paper.pdf: paper.md
presen.pdf: presen.md
C: C.dvi C.pdf C.html
unix: unix.dvi unix.pdf unix.html
unix-lesson: unix-lesson.dvi unix-lesson.pdf unix-lesson.html

clean:
	rm -f *.aux *.log *.bbl *.blg *.toc *.dvi *~ *.fdb_latexmk *.fls *.synctex.gz *-md.tex

all: paper presen math-lesson C unix unix-lesson install

.SUFFIXES: .tex .pdf

install:
	install unix.pdf unix-lesson.pdf C.pdf C-lesson.pdf ${HTMLDIR}

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
