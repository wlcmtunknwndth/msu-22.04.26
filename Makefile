# Lets generate a script to run marp PRESENTATION.md -o PRESENTATION.pdf

presentation:
	marp PRESENTATION.md -o PRESENTATION.pdf

clean:
	rm -f PRESENTATION.pdf

.PHONY: presentation clean