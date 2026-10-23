.DEFAULT_GOAL := all
.ONESHELL:
.SHELLFLAGS := -eu -c
.DELETE_ON_ERROR:
.PHONY: all clean distclean

XELATEX ?= xelatex
XELATEXFLAGS ?= -halt-on-error -file-line-error -interaction=nonstopmode
MAKEINDEX ?= makeindex

export SOURCE_DATE_EPOCH := 1790812800

BOOKS := $(notdir $(patsubst %/main.tex,%,$(wildcard src/*/main.tex)))
PDFS := $(addprefix build/,$(addsuffix .pdf,$(BOOKS)))

all: $(PDFS)

$(foreach book,$(BOOKS),$(eval build/$(book).pdf: $(shell find src/$(book) -type d -o -type f)))

$(PDFS): build/%.pdf: src/%/main.tex Makefile
	aux_dir="$(abspath build/.aux/$*)"
	mkdir -p "$$aux_dir"
	cd "src/$*"
	find . -type d -exec mkdir -p "$$aux_dir/{}" \;
	$(XELATEX) $(XELATEXFLAGS) -output-directory="$$aux_dir" main.tex
	$(XELATEX) $(XELATEXFLAGS) -output-directory="$$aux_dir" main.tex
	for pass in 1 2; do
		(
			cd "$$aux_dir"
			$(MAKEINDEX) -s main.ist -o main.ind -t main.ilg main.idx
		)
		$(XELATEX) $(XELATEXFLAGS) -output-directory="$$aux_dir" main.tex
	done
	mv -f "$$aux_dir/main.pdf" "$(abspath $@)"

clean:
	rm -rf build/.aux

distclean: clean
	rm -rf build
