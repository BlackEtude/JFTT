scan: scan.c
	gcc -o scan scan.c

scan.c: zad1.l
	flex -oscan.c zad1.l

clean:
	rm scan.c scan
