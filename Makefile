# Default Config Settings

SECTIONS_FILEPATH=config/_SECTIONS.txt
BUILDNAME=output
TEMPLATE=template.tex
CSL=elsevier-with-titles


# Load in new config settings
include config/_CONFIG.txt

# This combines all the filepaths in SECTIONS_FILEPATH file
SECTIONS := $(shell cat $(SECTIONS_FILEPATH) | sed -e 's/$$/\/\*.html/g' | tr '\n\r' ' ' | tr '\n' ' ' )


EXPORT_NAME=$(BUILDNAME)`date +'-%Y%m%d-%Hh%M.pdf'`

pre:
	mkdir -p build

post:
	@echo POST

clean:
	rm -rf build
	rm -rf source/*/
	rm -rf source/*.bib

makesource:
	mkdir -p source
	@while read p; do \
		cd ./source/ && \
		gdrive export $${p} --mime application/zip --force; \
		unzip *.zip -d $${p}; \
		rm *.zip; \
		cd ./$${p} && \
		sed -i -e 's/images\//\.\.\/source\/'$${p}'\/images\//g' *.html; \
		cd ..; \
		cd ..; \
	done <$(SECTIONS_FILEPATH)

makemeta:
	cd ./source/ && \
	gdrive export $(REFERENCES) --mime text/plain --force; \
	mv $(REFERENCES_NAME) references.bib; \
    gdrive export $(AFTER) --mime application/zip --force; \
    unzip *.zip -d $(AFTER); \
    rm *.zip; \
    cd ./$(AFTER) && \
    sed -i -e 's/images\//'$(AFTER)'\/images\//g' *.html; \
    cd ..; \
    gdrive export $(BEFORE) --mime application/zip --force; \
    unzip *.zip -d $(BEFORE); \
    rm *.zip; \
    cd ./$(BEFORE) && \
    sed -i -e 's/images\//'$(BEFORE)'\/images\//g' *.html; \
    cd ..; \
    cd ..; \

get: makesource makemeta

pdf: pre
		cd ./source/ && \
		pandoc --toc -N --normalize --bibliography=references.bib -o ../build/$(BUILDNAME).tex --csl=../csl/$(CSL).csl --template=../$(TEMPLATE) -f html -B $(BEFORE)/*.html $(SECTIONS) -A $(AFTER)/*.html --top-level-division=chapter --latex-engine=xelatex; \
		sed 's/~//g' ../build/$(BUILDNAME).tex > ../build/draft.tex; \
		cat ../build/draft.tex | tr -s ' ' ' ' > ../build/$(BUILDNAME).tex; \
        rm ../build/draft.tex; \
		cd .. ; \
		cd ./build/ && \
		xelatex ../build/$(BUILDNAME).tex

corepdf: pre
		cd ./source/ && \
		pandoc --toc -N --normalize --bibliography=../source/references -o ../build/$(BUILDNAME).tex --natbib --template=../$(TEMPLATE) -f html $(SECTIONS) --top-level-division=chapter --latex-engine=xelatex; \
		sed 's/~//g' ../build/$(BUILDNAME).tex > ../build/draft.tex; \
		cat ../build/draft.tex | tr -s ' ' ' ' | sed -r 's/\s:/~:/g' | sed -r 's/\\\{([A-Za-z0-9]+)\\\}/\\cite\{\1\}/g' | sed -r 's/\\\{\\\{/\\footnote\{/g' | sed -r 's/\\\}\\\}/\}/g'| sed -r "s/\{\\\includegraphics\{(.+)\}\}/\\\begin\{figure\}\[H\]\\\centering\\\includegraphics\{\1\}\\\caption\{\}\\\end\{figure\}/g" > ../build/$(BUILDNAME).tex; \
        rm ../build/draft.tex; \
		cd .. ; \
		cd ./build/ && \
		xelatex $(BUILDNAME);\
		bibtex $(BUILDNAME); \
		xelatex $(BUILDNAME); \
		xelatex $(BUILDNAME);

build: pre
		cd ./source/ && \
		pandoc --toc -N --normalize --bibliography=references.bib -o ../build/$(BUILDNAME).tex --csl=../csl/$(CSL).csl --template=../$(TEMPLATE) -f html -B $(BEFORE)/*.html $(SECTIONS) -A $(AFTER)/*.html --top-level-division=chapter --latex-engine=xelatex; \
		sed 's/~//g' ../build/$(BUILDNAME).tex > ../source/draft.tex; \
		sed -i 's/(\[\w+\])/\\cite{&}/g' ../build/draft.tex; \

md: pre
		cd ./source/ && \
		pandoc -o ../source/md.md -f html $(SECTIONS); \

create: clean pre get corepdf

export:
		gdrive upload --parent $(EXPORT) ./build/$(BUILDNAME).pdf --name $(EXPORT_NAME)

convert: create export

test: 
	echo "{\includegraphics{../source/1_k6O446ZEQZWZI4gBl1omyHJzByQLa50Fc0mFNFolss/images/image03.png}}\n\n{Test}" | sed -r "s/\{\\\includegraphics\{(.+)\}\}[[:blank:]][[:blank:]]\{(.+)\}/\\\begin\{figure\}\[h\]\\\centering\\\includegraphics\{\1\}\\\caption\{\}\\\end\{figure\}/g";

test2: 
	echo "Coucou\nCoucou" | sed -r "s/Coucou\\SCoucou/Yes/g"
