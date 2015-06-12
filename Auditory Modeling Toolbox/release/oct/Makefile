OCTS = comp_adaptloop.oct

all:	$(OCTS)

%.oct: %.cc Makefile
	mkoctfile -Wall -I. $<

clean:
	rm *.oct

.PHONY: all clean