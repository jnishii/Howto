HTMLDIR=/home/zeus/httpd/html/texts
HTMLDIR_LAB=/home/zeus/httpd/html/lab/texts
LATEX2HTML=latex2html -split +1
#LATEX2HTML=hevea
HEVEA=hevea
CP=cp -dRuv
.SUFFIXES: .md .pdf .tex .dvi

clean:
	rm -f *.aux *.log *.bbl *.blg *.toc *.dvi *~ *.fdb_latexmk *.fls *.synctex.gz

clean-all:
	rm -rf paper math-lesson C unix unix-lesson install back-restore lam

all: paper presen math-lesson C unix unix-lesson install back-restore lam

install: install-paper install-math install-C install-unix install-install\
	install-ulesson install-presen install-plesson install-back-restore\
	install-htaccess install-lam

### use hevea for html conversion for the following documents
install-paper: paper
	chmod 664 $<.{pdf,ps,dvi,html}
	${CP} $<.pdf ${HTMLDIR}
	${CP} $<.ps ${HTMLDIR}
	${CP} $<.dvi ${HTMLDIR}
	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
#	chmod 775 $<
#	${CP} -dur $< ${HTMLDIR}

install-C: C
	chmod 664 $<.{pdf,ps,dvi,html}
	${CP} $<.pdf ${HTMLDIR}
	${CP} $<.ps ${HTMLDIR}
	${CP} $<.dvi ${HTMLDIR}
	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
#	chmod 775 $<
#	${CP} -dur $< ${HTMLDIR}

install-unix: unix
	chmod 664 $<.{pdf,ps,dvi,html}
	${CP} $<.pdf ${HTMLDIR}
	${CP} $<.ps ${HTMLDIR}
	${CP} $<.dvi ${HTMLDIR}
	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
#	chmod 775 $<
#	${CP} -dur $< ${HTMLDIR}

install-ulesson: unix-lesson
	chmod 664 $<.{pdf,ps,dvi,html}
	${CP} $<.pdf ${HTMLDIR}
	${CP} $<.ps ${HTMLDIR}
	${CP} $<.dvi ${HTMLDIR}
	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
#	chmod 775 $<
#	${CP} -dur $< ${HTMLDIR}

install-presen: presen
	chmod 664 $<.{pdf,ps,dvi,html}
	${CP} $<.pdf ${HTMLDIR}
	${CP} $<.ps ${HTMLDIR}
	${CP} $<.dvi ${HTMLDIR}
	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
#	chmod 775 $<
#	${CP} -dur $< ${HTMLDIR}

install-install: uinstall install-htaccess
	chmod 664 install.{pdf,ps,dvi,html}
	${CP} install.pdf ${HTMLDIR_LAB}
	${CP} install.ps ${HTMLDIR_LAB}
	${CP} install.dvi ${HTMLDIR_LAB}
	sed 's/ISO-8859-1/euc-jp/' install.html > ${HTMLDIR_LAB}/install.html
#	chmod 775 install
#	${CP} -dur install ${HTMLDIR_LAB}

### use latex2html for html conversion for the following documents
install-back-restore: back-restore
	${LATEX2HTML} $<
	chmod 664 back-restore.{pdf,ps,dvi,html}
	${CP} back-restore.pdf ${HTMLDIR_LAB}
	${CP} back-restore.ps ${HTMLDIR_LAB}
	${CP} back-restore.dvi ${HTMLDIR_LAB}
#	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
	chmod 775 $<
	chmod 664 $</*
	${CP} -dur $< ${HTMLDIR_LAB}

install-lam: lam
	${LATEX2HTML} $<
	chmod 664 lam.{pdf,ps,dvi}
	${CP} lam.pdf ${HTMLDIR_LAB}
	${CP} lam.ps ${HTMLDIR_LAB}
	${CP} lam.dvi ${HTMLDIR_LAB}
	${CP} info_mpi.tgz ${HTMLDIR_LAB}
#	sed 's/ISO-8859-1/euc-jp/' $<.html > ${HTMLDIR}/$<.html
	chmod 775 $<
	chmod 664 $</*
	${CP} -dur $< ${HTMLDIR_LAB}

install-math: math-lesson
	${LATEX2HTML} $<
	chmod 664 $<.{pdf,ps,dvi}
	${CP} $<.pdf ${HTMLDIR}
	${CP} $<.ps ${HTMLDIR}
	chmod 775 $<
	chmod 664 $</*
	${CP} -dur $< ${HTMLDIR}

install-htaccess:
	${CP} htaccess ${HTMLDIR}/.htaccess
	${CP} install_htaccess ${HTMLDIR_LAB}/install/.htaccess

## hevea
paper: paper.dvi paper.ps paper.pdf paper.html
presen: presen.dvi presen.ps presen.pdf presen.html
C: C.dvi C.ps C.pdf C.html
unix: unix.dvi unix.ps unix.pdf unix.html
unix-lesson: unix-lesson.dvi unix-lesson.ps unix-lesson.pdf unix-lesson.html
uinstall: install.ps install.pdf install.html

## latex2html
#math-lesson: math-lesson.dvi math-lesson.ps math-lesson.pdf math-lesson.html
math-lesson: math-lesson.dvi math-lesson.ps math-lesson.pdf
	${LATEX2HTML} $<

back-store: back-restore.dvi back-restore.ps back-restore.pdf
	${LATEX2HTML} $<

lam: lam.dvi lam.ps lam.pdf
	${LATEX2HTML} $<

.SUFFIXES: .tex .ps .html .pdf

.tex.dvi:
	platex $<
	platex $<
	platex $<

.tex.html:
	${HEVEA} $<
	${HEVEA} $< # requires two run to check label info
#	${LATEX2HTML} $<

.dvi.ps:
	dvips $<

.dvi.pdf:
	dvipdfmx $<


.md.pdf:
	md2ptex $<
	platex $*-md.tex
	platex $*-md.tex
	dvipdfmx $*-md.dvi
	mv $*-md.pdf $*.pdf

