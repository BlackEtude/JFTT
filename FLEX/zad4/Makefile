scan: scan.c
	gcc -o scan scan.c -lm

scan.c: zad4.l
	flex -oscan.c zad4.l

clean:
	rm scan.c scan
