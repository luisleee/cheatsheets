RM := rm -rf

all:

clean:
	$(RM) *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz

.PHONY: all clean
