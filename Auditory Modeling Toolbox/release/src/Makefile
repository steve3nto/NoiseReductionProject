# Use GNU Make to process this file
CC = gcc
CFLAGS=-O2 -Wall -fPIC -std=c99

files = adaptloop.o meddishaircell.o strube1985.o

all: libamtoolbox.a verhulst2012

libamtoolbox.a: $(files) 
	ar rvu libamtoolbox.a $(files_unix)
	ranlib libamtoolbox.a

verhulst2012:
	$(MAKE) -C verhulst

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $<

clean:
	rm *.o *.a
	$(MAKE) -C verhulst clean
